package helper

import (
	"crypto/tls"
	"crypto/x509"
	"google.golang.org/grpc/credentials"
	"io/ioutil"
	"log"
)
//GetServerCreds 创建双向验证服务器证书
func GetServerCreds() credentials.TransportCredentials{
	// 加载双向验证证书形式
	// 使用tls 进行加载  key pair
	cert, err := tls.LoadX509KeyPair("cert/server.pem", "cert/server.key")
	if err != nil {
		log.Println("tls 加载x509 证书失败", err)
	}
	// 创建证书池
	certPool := x509.NewCertPool()

	// 向证书池中加入证书
	cafileBytes, err := ioutil.ReadFile("cert/ca.pem")
	if err != nil {
		log.Println("读取ca.pem证书失败", err)
	}
	// 加载客户端证书
	//certPool.AddCert()

	// 加载证书从pem 文件里面
	certPool.AppendCertsFromPEM(cafileBytes)

	// 创建credentials 对象
	creds := credentials.NewTLS(&tls.Config{
		Certificates: []tls.Certificate{cert},        //服务端证书
		ClientAuth:   tls.RequireAndVerifyClientCert, // 需要并且验证客户端证书
		ClientCAs:    certPool,                       // 客户端证书池

	})
	return  creds
}
// GetClientCreds 创建客服端双向验证证书
func GetClientCreds()credentials.TransportCredentials{
	// 和server端一样，先创建证书池
	cert, err := tls.LoadX509KeyPair("cert/client.pem","cert/client.key")
	if err!= nil{
		log.Println("加载client pem, key 失败",err)
	}

	certPool := x509.NewCertPool()
	caFile ,err :=  ioutil.ReadFile("cert/ca.pem")
	if err!= nil{
		log.Println("加载ca失败",err)
	}
	certPool.AppendCertsFromPEM(caFile)

	creds := credentials.NewTLS(&tls.Config{
		Certificates: []tls.Certificate{cert},// 放入客户端证书
		ServerName: "localhost", //证书里面的 commonName
		RootCAs: certPool, // 根证书池
	})
	return  creds
}