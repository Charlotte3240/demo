package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/protobuf/types/known/timestamppb"
	"log"
	"nsqk.com/rpc/helper"
	. "nsqk.com/rpc/services"
)

func main() {
	useClientPemFile()
}

func useClientPemFile(){
	creds := helper.GetClientCreds()

	ctx := context.Background()
	ctx,cancel := context.WithCancel(ctx)
	defer cancel()


	conn, err := grpc.Dial(":2333", grpc.WithTransportCredentials(creds))
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	client := NewHelloWorldClient(conn)

	replay ,err := client.HelloRPC(ctx,&SayHelloRequest{
		Name: "Hello world req",
	})

	if err != nil {
		fmt.Println("hello rpc error:", err)
	} else {
		fmt.Println("hello result message :", replay.Message)
	}

	prodClient := NewProdServiceClient(conn)
	ret,err := prodClient.GetProdStock(ctx,&ProdRequest{
		ProdId: 1,
		ProdArea: 3,
	})
	if err != nil {
		fmt.Println("prod rpc error:", err)
	} else {
		fmt.Println("prod result message :", ret.ProdStock)
	}

	orderClient := NewOrderServiceClient(conn)
	orderRes ,err := orderClient.NewOrder(ctx,&OrderInfo{
		OrderId: 1,
		OrderNo: 0001,
		OrderUserId: 1234,
		OrderPrice: 19.5,
		OrderTime: timestamppb.Now(),

	})
	if err != nil{
		log.Println("创建订单失败",err)
	}else {
		log.Println(orderRes.Status,orderRes.Msg)
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

	client := NewHelloWorldClient(conn)
	replay, err := client.HelloRPC(context.Background(), &SayHelloRequest{
		Name: "hello world name",
	})
	if err != nil {
		fmt.Println("rpc error:", err)
	} else {
		fmt.Println("result message :", replay.Message)
	}
}
