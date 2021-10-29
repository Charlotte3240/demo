package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/reflection"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"nsqk.com/rpc/services"
)

func main() {
	//startGRPCHttpServer()
	//startGRPCServer()
	startTwoWayCertGRPCServer()
	fmt.Println("ddd")
}

// startTwoWayCertGRPCServer 双向证书验证
func startTwoWayCertGRPCServer() {
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

	lis, err := net.Listen("tcp", ":2333")
	if err != nil {
		fmt.Println("监听端口失败 err:", err)
	}
	s := grpc.NewServer(grpc.Creds(creds))
	services.RegisterHelloWorldServer(s, new(services.HelloService))

	reflection.Register(s)

	err = s.Serve(lis)
	fmt.Println("gRPC starting")
	if err != nil {
		fmt.Println("启动grpc失败 err:", err)
	} else {
		fmt.Println("gRPC started")
	}
}

func startGRPCHttpServer() {
	// 1. 加载证书
	creds, err := credentials.NewServerTLSFromFile("keys/server.pem", "keys/server.key")
	if err != nil {
		log.Fatalln("加载证书失败", err)
		return
	}

	s := grpc.NewServer(grpc.Creds(creds))
	services.RegisterHelloWorldServer(s, new(services.HelloService))
	// 注册grpc server
	reflection.Register(s)

	// 开启一个httpserver 路由
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		// 打印req
		log.Println(request)
		s.ServeHTTP(writer, request)
	})
	httpServer := &http.Server{
		Addr:    ":2333",
		Handler: mux,
	}
	// gRPC requires HTTP/2
	// 默认grpc 走h2协议
	//httpServer.ListenAndServe()

	// 下面的方式启动，就可以通过https来进行访问了
	httpServer.ListenAndServeTLS("keys/server.pem", "keys/server.key")

}

func startGRPCServer() {
	// 加载证书
	creds, err := credentials.NewServerTLSFromFile("keys/server.pem", "keys/server.key")
	if err != nil {
		log.Fatalln("加载证书失败", err)
	}

	lis, err := net.Listen("tcp", ":2333")
	if err != nil {
		fmt.Println("监听端口失败 err:", err)
	}
	s := grpc.NewServer(grpc.Creds(creds))
	services.RegisterHelloWorldServer(s, new(services.HelloService))

	reflection.Register(s)

	err = s.Serve(lis)
	if err != nil {
		fmt.Println("启动grpc失败 err:", err)
	}
}
