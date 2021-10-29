package main

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"io/ioutil"
	"log"
	"nsqk.com/rpc/services"
)

func main() {
	useClientPemFile()
}

func useClientPemFile(){
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
