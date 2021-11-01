package main

import (
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/reflection"
	"log"
	"net"
	"net/http"
	"nsqk.com/rpc/helper"
	"nsqk.com/rpc/services"
)

func main() {
	//startGRPCHttpServer()
	//startGRPCServer()
	startTwoWayCertGRPCServer()
}

// startTwoWayCertGRPCServer 双向证书验证
func startTwoWayCertGRPCServer() {
	lis, err := net.Listen("tcp", ":2333")
	if err != nil {
		fmt.Println("监听端口失败 err:", err)
	}
	s := grpc.NewServer(grpc.Creds(helper.GetServerCreds()))
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
