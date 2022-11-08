package main

import (
	//"context"
	//"fmt"
	//"google.golang.org/grpc"
	//"google.golang.org/grpc/credentials"
	//"google.golang.org/protobuf/types/known/timestamppb"
	//"log"
	//"nsqk.com/rpc/helper"
	//. "nsqk.com/rpc/services"
	"context"
	"fmt"
	"io"
	"log"
	"nskq.com/rpc/helper"
	proto "nskq.com/rpc/vmatch"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/protobuf/types/known/timestamppb"
	. "nskq.com/rpc/services"
)

func main() {
	//使用双向验证证书
	//useClientPemFile()
	// 使用服务器证书
	//useServerPemFile()

	testAsv()
}

func testAsv() {
	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	conn, err := grpc.Dial(":50053", grpc.WithInsecure())
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	client := proto.NewSpeechMatchClient(conn)

	res, err := client.Init(ctx, &proto.InitRequest{
		Session: "123456",
		AudioInfo: &proto.AudioSpec{
			ReversesBytes: false,
			NumChannels:   2,
			SampleRate:    8000,
			BitsPerSample: 200,
		},
		AppCode:  "no_web_video",
		Customer: "1234",
	})
	if err != nil {
		log.Println("client init fail", err)
		return
	}
	log.Printf("get init res : %#v \n", res)

}

// MARK: - 使用双向认证证书
func useClientPemFile() {
	creds := helper.GetClientCreds()

	ctx := context.Background()
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	conn, err := grpc.Dial(":2333", grpc.WithTransportCredentials(creds))
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	client := NewHelloWorldClient(conn)

	replay, err := client.HelloRPC(ctx, &SayHelloRequest{
		Name: "Hello world req",
	})

	if err != nil {
		fmt.Println("hello rpc error:", err)
	} else {
		fmt.Println("hello result message :", replay.Message)
	}

	prodClient := NewProdServiceClient(conn)
	ret, err := prodClient.GetProdStock(ctx, &ProdRequest{
		ProdId:   1,
		ProdArea: 3,
	})
	if err != nil {
		fmt.Println("prod rpc error:", err)
	} else {
		fmt.Println("prod result message :", ret.ProdStock)
	}

	orderClient := NewOrderServiceClient(conn)
	orderRes, err := orderClient.NewOrder(ctx, &OrderRequest{
		OrderInfo: &OrderInfo{
			OrderId:     1,
			OrderNo:     0001,
			OrderUserId: 1234,
			OrderPrice:  19.5,
			OrderTime:   timestamppb.Now(),
			OrderDetails: []*OrderDetail{
				&OrderDetail{
					OrderDetailId: 11,
					OrderDetailNo: 22,
					OrderNo:       0001,
					OrderType:     02,
					OrderNum:      3,
				},
				&OrderDetail{
					OrderDetailId: 11,
					OrderDetailNo: 22,
					OrderNo:       0001,
					OrderType:     02,
					OrderNum:      3,
				},
			},
		},
	})

	if err != nil {
		log.Println("创建订单失败", err)
	} else {
		log.Println(orderRes.Status, orderRes.Msg)
	}
	// user score 请求
	userClient := NewUserServiceClient(conn)
	// 批量20个用户
	var usersReq = &UserScoreRequest{
		UserInfos: []*UserInfo{},
	}
	for i := 0; i < 99; i++ {
		usersReq.UserInfos = append(usersReq.UserInfos, &UserInfo{
			UserId: int32(10000 + i),
		})
	}
	// 普通grpc 请求模式
	//normalGPRCMode(ctx,userClient,usersReq)
	// 客户端流模式
	//clientStreamMode(ctx,userClient,usersReq)
	// 服务端流模式
	//serverStreamMode(ctx,userClient,usersReq)
	// 双向流模式
	bidStreamMode(ctx, userClient, usersReq)

}

// 普通gRPC请求
func normalGPRCMode(ctx context.Context, userClient UserServiceClient, usersReq *UserScoreRequest) {
	userReplay, err := userClient.QueryUserScore(ctx, usersReq)
	if err != nil {
		log.Println("query user error ", err)
	} else {
		for _, userInfo := range userReplay.UserInfos {
			log.Println("userId:", userInfo.UserId, "userScore:", userInfo.UserScore)
		}
	}
}

// clientStreamMode 客户端流模式
func clientStreamMode(ctx context.Context, userClient UserServiceClient, usersReq *UserScoreRequest) {
	//客户端流模式
	// 创建流模式客户端
	clientStream, err := userClient.QueryUserScoreByClientStream(ctx)
	if err != nil {
		log.Println("创建客户端流失败", err.Error())
		return
	}
	// 发送3批req
	for i := 0; i < 3; i++ {
		req := UserScoreRequest{}
		req.UserInfos = usersReq.UserInfos
		err = clientStream.Send(&req)
		if err != nil {
			log.Println("send req error ", err.Error())
			continue
		}
		time.Sleep(time.Second * 2)
	}
	// 发送完毕，接收结果
	clientStreamRes, err := clientStream.CloseAndRecv()
	if err != nil {
		log.Println("client stream 流模式接收失败", err.Error())
		return
	}
	log.Println("client stream result:", clientStreamRes)
}

// serverStreamMode 服务端流模式
func serverStreamMode(ctx context.Context, userClient UserServiceClient, usersReq *UserScoreRequest) {
	// 改用服务端流的 service
	stream, err := userClient.QueryUserScoreByServerStream(ctx, usersReq)
	if err != nil {
		log.Println("读取users stream 出错", err.Error())
	}
	for {
		users, err := stream.Recv()
		if err != nil {
			if err == io.EOF {
				//读取完毕
				log.Println("读取完毕")
				break
			}
			log.Println("从stream中读取错误", err.Error())
			break
		}
		log.Println("get userinfos:", users)
		//for _, userInfo := range users.UserInfos {
		//	log.Println("stream: - userId:", userInfo.UserId, "userScore:", userInfo.UserScore)
		//}
	}

}

// bidStreamMode 双向流模式
func bidStreamMode(ctx context.Context, userClient UserServiceClient, usersReq *UserScoreRequest) {
	stream, err := userClient.QueryUserScoreByTWS(ctx)
	if err != nil {
		log.Println("创建双向流Stream失败", err.Error())
		return
	}
	// read from server stream
	go func() {
		for {
			res, err := stream.Recv()
			if err != nil {
				log.Println("get data from server stream error ", err.Error())
				continue
			}
			log.Println("userInfos is ", res)
		}
	}()
	// send data to server use stream
	for i := 0; i < 3; i++ {
		if err := stream.Send(usersReq); err != nil {
			log.Println("发送user req 失败", err.Error())
		}
		time.Sleep(time.Second)
	}
	// time.Sleep(10 * time.Second)
	// if err := stream.CloseSend(); err != nil {
	// 	log.Println("close send err ", err)
	// }

}

// MARK: - 使用服务端证书
func useServerPemFile() {
	// 加载证书，创建credentials
	// 这里的serverNameOverride 要填写服务端的地址
	creds, err := credentials.NewClientTLSFromFile("keys/server.pem", "127.0.0.1")

	if err != nil {
		log.Fatalln("加载证书失败", err)
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
