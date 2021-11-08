package main

import (
	"context"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"google.golang.org/grpc"
	"log"
	"net/http"
	"nsqk.com/rpc/helper"
	"nsqk.com/rpc/services/Gateway"
)

func main() {
	ctx := context.Background()
	ctx,cancel := context.WithCancel(ctx)
	defer cancel()

	// 创建一个gateway mux
	gwmux := runtime.NewServeMux()
	// 创建grpc client dial 配置项
	// 这里把RESTful api 转成 gRPC client 去请求，所以传入客户端的证书
	opt := []grpc.DialOption{grpc.WithTransportCredentials(helper.GetClientCreds())}
	// 注册并且设置http的handler，这里传入的endpoint 是gRPC server的地址
	err := services.RegisterHelloWorldHandlerFromEndpoint(ctx,gwmux,"localhost:2333",opt)
	if err != nil{
		log.Fatalln("注册hello grpc转发失败:",err)
	}
	err = services.RegisterProdServiceHandlerFromEndpoint(ctx,gwmux,"localhost:2333",opt)
	if err != nil{
		log.Fatalln("注册prod grpc转发失败:",err)
	}

	err = services.RegisterOrderServiceHandlerFromEndpoint(ctx,gwmux,"localhost:2333",opt)
	if err != nil{
		log.Fatalln("注册order grpc转发失败")
	}


	httpServer := &http.Server{
		Addr: ":23333",
		Handler: gwmux,
	}
	err = httpServer.ListenAndServe()
	if err != nil{
		log.Fatalln("http 启动失败:",err)
	}


}


func wssHandler(){
	http.HandleFunc("/v1/ws", func(writer http.ResponseWriter, request *http.Request) {
		conn , _ := websocket.u
	})
}