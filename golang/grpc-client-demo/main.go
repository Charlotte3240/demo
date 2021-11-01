package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"log"
	"nsqk.com/rpc/helper"
	"nsqk.com/rpc/services"
)

func main() {
	useClientPemFile()
}

func useClientPemFile(){
	creds := helper.GetClientCreds()

	conn, err := grpc.Dial(":2333", grpc.WithTransportCredentials(creds))
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	client := services.NewHelloWorldClient(conn)
	replay, err := client.HelloRPC(context.Background(), &services.SayHelloRequest{
		Name: "hello world name",
	})
	if err != nil {
		fmt.Println("rpc error:", err)
	} else {
		fmt.Println("result message :", replay.Message)
	}

}


func useServerPemFile(){
	// 加载证书，创建credentials
	// 这里的serverNameOverride 要填写服务端的地址
	creds ,err := credentials.NewClientTLSFromFile("keys/server.pem","127.0.0.1")

	if err!= nil{
		log.Fatalln("加载证书失败",err)
	}

	conn, err := grpc.Dial(":2333", grpc.WithTransportCredentials(creds))
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	client := services.NewHelloWorldClient(conn)
	replay, err := client.HelloRPC(context.Background(), &services.SayHelloRequest{
		Name: "hello world name",
	})
	if err != nil {
		fmt.Println("rpc error:", err)
	} else {
		fmt.Println("result message :", replay.Message)
	}
}
