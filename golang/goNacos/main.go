package main

import (
	"fmt"
	"github.com/nacos-group/nacos-sdk-go/clients"
	"github.com/nacos-group/nacos-sdk-go/clients/naming_client"
	"github.com/nacos-group/nacos-sdk-go/common/constant"
	"github.com/nacos-group/nacos-sdk-go/model"
	"github.com/nacos-group/nacos-sdk-go/vo"
	"gopkg.in/yaml.v2"
	"io"
	"log"
	"net"
	"net/http"
	"strconv"
	"strings"
)

type Config struct {
	LogFile   string `yaml:"logFile"`
	TTSPort   string `yaml:"ttsPort"`
	MongoAuth string `yaml:"mongoAuth"`
}

var TTSConf = &Config{}

const (
	dev = "e73a166f-b803-4504-a6cb-62665bebcfa6"
	uat = "8d4169b5-81ad-42d9-b3b7-84347e9ec89a"
	pdt = "5d1cbad3-843e-4a88-b479-a94f000d2a00"
)

func main() {
	nacosIp := "127.0.0.1"
	nacosPort := uint64(8848)
	nacosDataId := "ttsConf"
	nacosGroupId := "tts"
	nacosNameSpaceId := dev

	// 可以添加多个nacos地址
	serverConfs := []constant.ServerConfig{
		{
			IpAddr:      nacosIp,
			Port:        nacosPort,
			ContextPath: "/nacos",
			Scheme:      "http",
		},
	}

	clientConf := &constant.ClientConfig{
		NamespaceId:          nacosNameSpaceId,
		TimeoutMs:            5000,
		AppName:              "proxy",
		UpdateCacheWhenEmpty: true,
	}

	client, err := clients.NewConfigClient(
		vo.NacosClientParam{
			ClientConfig:  clientConf,
			ServerConfigs: serverConfs,
		},
	)
	if err != nil {
		log.Fatalln("nacos 初始化配置客户端失败", err)
	}

	// 获取tts 配置信息
	conf, err := client.GetConfig(vo.ConfigParam{
		DataId: nacosDataId,
		Group:  nacosGroupId,
	})
	if err != nil {
		log.Fatalln("nacos 读取配置失败", err)
	}

	// 获取mongo 配置信息
	pyConf, err := client.GetConfig(vo.ConfigParam{
		DataId: "ttsMongo",
		Group:  "mongo",
	})
	log.Printf("mongo 配置文件:\n %v", pyConf)

	UpdateLocalConfig(conf)

	//namingClient, err := clients.NewNamingClient(vo.NacosClientParam{
	//	ClientConfig:  clientConf,
	//	ServerConfigs: serverConfs})
	//if err != nil {
	//	log.Fatalln("nacos 初始化服务发现 客户端失败", err)
	//}

	// 监听配置信息
	go func() {
		err := client.ListenConfig(vo.ConfigParam{
			DataId: nacosDataId,
			Group:  nacosGroupId,
			OnChange: func(namespace, group, dataId, data string) {
				UpdateLocalConfig(conf)
				log.Println("namespace:", namespace, "group:", group, "dataId:", dataId, "data:", TTSConf)
			},
		})
		if err != nil {
			log.Println("nacos 监听配置文件失败", err)
		}
	}()
	// 注册服务信息
	go func(portStr string) {
		ip, err := GetOutBoundIP()
		if err != nil {
			log.Println("获取本地ip失败", err)
			return
		}
		if strings.Contains(portStr, ":") {
			subStrs := strings.Split(portStr, ":")
			portStr = subStrs[len(subStrs)-1]
		}
		port, err := strconv.ParseUint(portStr, 10, 64)
		if err != nil {
			log.Println("获取的port 配置信息错误", err)
			return
		}

		namingClient, err := clients.NewNamingClient(vo.NacosClientParam{
			ClientConfig:  clientConf,
			ServerConfigs: serverConfs})
		if err != nil {
			log.Fatalln("nacos 初始化服务发现 客户端失败", err)
		}
		ok, err := namingClient.RegisterInstance(vo.RegisterInstanceParam{
			Ip:      ip,
			Port:    port,
			Weight:  10,
			Enable:  true,
			Healthy: true,
			Metadata: map[string]string{
				"key": "value",
			},
			ClusterName: "DEFAULT", // 默认是DEFAULT
			ServiceName: "tts.proxy",
			GroupName:   "DEFAULT_GROUP", // 默认是DEFAULT_GROUP
			Ephemeral:   true,            // 是否为临时实例
		})
		if ok {
			log.Println("服务实例注册成功")
		}
		if err != nil {
			log.Println("服务实例注册失败", err)
		}
	}(TTSConf.TTSPort)

	//SubscribeService(namingClient)

	//time.Sleep(time.Second * 3)
	//GetAllServicesInfo(namingClient)
	//GetAllInstances(namingClient)
	//GetServiceInfo(namingClient)
	//GetInstances(namingClient)
	//GetOneHealthyInstance(namingClient)
	//UnSubscribeService(namingClient)
	//UnRegisterService(clientConf, serverConfs)

	http.HandleFunc("/", sayhello)
	http.ListenAndServe(":8080", nil)

}

func sayhello(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "hello world")
}

//GetAllServicesInfo 获取所有服务信息
func GetAllServicesInfo(namingClient naming_client.INamingClient) (list model.ServiceList, ok bool) {
	services, err := namingClient.GetAllServicesInfo(vo.GetAllServiceInfoParam{
		NameSpace: dev,
		GroupName: "DEFAULT_GROUP",
		PageNo:    1,
		PageSize:  10,
	})
	log.Println("所有服务信息", services.Count, services.Doms, len(services.Doms))

	if err != nil {
		log.Println("获取所有服务信息失败", err)
		return model.ServiceList{}, false
	}
	return services, true
}

//UnSubscribeService 取消监听服务变化
func UnSubscribeService(namingClient naming_client.INamingClient) {
	err := namingClient.Unsubscribe(&vo.SubscribeParam{
		ServiceName:       "tts.proxy",
		Clusters:          nil,
		GroupName:         "",
		SubscribeCallback: nil,
	})
	if err != nil {
		log.Println("取消监听失败", err)
	} else {
		log.Println("取消监听成功")
	}
}

// SubscribeService 监听服务变化
func SubscribeService(namingClient naming_client.INamingClient) {
	err := namingClient.Subscribe(&vo.SubscribeParam{
		ServiceName: "tts.proxy",
		Clusters:    nil,
		GroupName:   "",
		SubscribeCallback: func(services []model.SubscribeService, err error) {
			if err != nil {
				log.Println("监听服务失败", err)
			}
			for _, service := range services {
				log.Printf("服务信息变化:%#v", service)
			}
		},
	})
	if err != nil {
		log.Println("监听服务变化失败", err)
	} else {
		log.Println("开始监听服务变化")
	}

}

//GetOneHealthyInstance 获取一个健康的实例
func GetOneHealthyInstance(namingClient naming_client.INamingClient) (instance *model.Instance, ok bool) {
	instance, err := namingClient.SelectOneHealthyInstance(vo.SelectOneHealthInstanceParam{
		Clusters:    nil,
		ServiceName: "tts.proxy",
		GroupName:   "",
	})
	if err != nil {
		log.Println("获取一个健康的实例失败", err)
		return nil, false
	}
	log.Println("InstanceId", instance.InstanceId)
	log.Println("ip", instance.Ip)
	log.Println("port", instance.Port)
	log.Println("serviceName", instance.ServiceName)
	log.Println("healthy", instance.Healthy)
	return instance, true
}

// GetInstances 根据条件来筛选实例
func GetInstances(namingClient naming_client.INamingClient) (instances []model.Instance, ok bool) {
	instances, err := namingClient.SelectInstances(vo.SelectInstancesParam{
		Clusters:    nil,
		ServiceName: "tts.proxy",
		GroupName:   "",
		HealthyOnly: true, // 筛选健康的实例
	})
	if err != nil {
		log.Println("筛选实例失败", err)
		return nil, false
	}
	for index, instance := range instances {
		log.Println("实例:", index)
		log.Println("InstanceId", instance.InstanceId)
		log.Println("ip", instance.Ip)
		log.Println("port", instance.Port)
		log.Println("serviceName", instance.ServiceName)
		log.Println("healthy", instance.Healthy)
	}
	return instances, true
}

// GetAllInstances  获取所有实例列表
func GetAllInstances(namingClient naming_client.INamingClient) (instances []model.Instance, ok bool) {
	instances, err := namingClient.SelectAllInstances(vo.SelectAllInstancesParam{
		Clusters:    nil,
		ServiceName: "tts.proxy",
		GroupName:   "",
	})
	if err != nil {
		log.Println("获取所有实例列表失败", err)
		return nil, false
	}
	for index, instance := range instances {
		log.Println("实例:", index)
		log.Println("InstanceId", instance.InstanceId)
		log.Println("ip", instance.Ip)
		log.Println("port", instance.Port)
		log.Println("serviceName", instance.ServiceName)
		log.Println("healthy", instance.Healthy)
	}
	return instances, true
}

//GetServiceInfo 获取服务信息
func GetServiceInfo(namingClient naming_client.INamingClient) model.Service {
	service, err := namingClient.GetService(vo.GetServiceParam{
		Clusters:    nil,
		ServiceName: "tts.proxy",
		GroupName:   "",
	})
	if err != nil {
		log.Println("获取服务信息失败", err)
	}
	log.Printf("获取的服务信息为%#v \n", service)
	return service
}

//UnRegisterService 注销服务
func UnRegisterService(clientConf *constant.ClientConfig, serverConf []constant.ServerConfig) bool {
	namingClient, err := clients.NewNamingClient(vo.NacosClientParam{
		ClientConfig:  clientConf,
		ServerConfigs: serverConf,
	})
	if err != nil {
		log.Println("create naming client error", err)
	}
	ip, err := GetOutBoundIP()
	if err != nil {
		log.Println("获取本地ip失败", err)
		return false
	}
	var portStr string
	if strings.Contains(TTSConf.TTSPort, ":") {
		subStrs := strings.Split(TTSConf.TTSPort, ":")
		portStr = subStrs[len(subStrs)-1]
	}
	port, err := strconv.ParseUint(portStr, 10, 64)
	if err != nil {
		log.Println("获取的port 配置信息错误", err)
		return false
	}
	ok, err := namingClient.DeregisterInstance(vo.DeregisterInstanceParam{
		Ip:          ip,
		Port:        port,
		Cluster:     "",
		ServiceName: "tts.proxy",
		GroupName:   "",
		Ephemeral:   true,
	})
	if err != nil {
		log.Println("注销服务实例失败", err)
		return false
	}
	if ok {
		log.Println("注销服务实例成功")
	}
	return true
}

//UpdateLocalConfig 更新本地配置文件
func UpdateLocalConfig(data string) bool {
	err := yaml.Unmarshal([]byte(data), TTSConf)
	if err != nil {
		log.Println("unmarshal yaml tts conf error", err)
		return false
	}
	return true
}

//GetOutBoundIP 获取本地出口ip
func GetOutBoundIP() (ip string, err error) {
	conn, err := net.Dial("udp", "8.8.8.8:53")
	if err != nil {
		fmt.Println(err)
		return
	}
	localAddr := conn.LocalAddr().(*net.UDPAddr)
	log.Println("本机出口ip", localAddr.String())
	ip = strings.Split(localAddr.String(), ":")[0]
	return
}
