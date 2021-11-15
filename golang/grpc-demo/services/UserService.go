package services

import (
	"context"
	"io"
	"log"
	"math/rand"
	"time"
)

type UserService struct {
}

// QueryUserScoreByTWS
//双向流模式
func (u *UserService) QueryUserScoreByTWS(stream UserService_QueryUserScoreByTWSServer) error {
	for {
		// read data from client
		recv, err := stream.Recv()
		if err == io.EOF{
			log.Println("no data")
			return nil
		}
		if err != nil {
			return err
		}
		// biz dealWith code
		for index, _ := range recv.UserInfos {
			recv.UserInfos[index].UserScore = float32(rand.Intn(100))
		}
		// send data to client
		if err := stream.Send(&UserScoreResponse{UserInfos: recv.UserInfos}); err !=nil{
			log.Println("send data to client error ",err.Error())
			return err
		}
	}
	return nil
}

//QueryUserScoreByClientStream
// 客户端流模式
func (u *UserService) QueryUserScoreByClientStream(stream UserService_QueryUserScoreByClientStreamServer) error {
	res := make([]*UserInfo, 0)
	for {
		req, err := stream.Recv()
		if err == io.EOF {
			//读取完了,跳出循环去发送
			break
		}
		if err != nil {
			log.Println("receive req err ", err.Error())
			return err
		}
		log.Println(req)
		res = append(res, req.UserInfos...)
		for _, userInfo := range res {
			// 业务处理代码，对score 进行一个随机数赋值
			userInfo.UserScore = float32(rand.Intn(100))
		}
	}
	// 发送结果
	err := stream.SendAndClose(&UserScoreResponse{
		UserInfos: res,
	})
	if err != nil {
		log.Println("send result err ", err.Error())
		return err
	}
	return nil
}

//QueryUserScoreByServerStream
// 服务端流处理模式
func (u *UserService) QueryUserScoreByServerStream(req *UserScoreRequest, stream UserService_QueryUserScoreByServerStreamServer) error {
	res := make([]*UserInfo, 0)
	for i := 0; i < len(req.UserInfos); i++ {
		res = append(res, &UserInfo{
			UserId:    req.UserInfos[i].UserId,
			UserScore: float32(rand.Intn(100)),
		})

		if (i+1)%2 == 0 && i > 0 {
			err := stream.Send(&UserScoreResponse{UserInfos: res})
			if err != nil {
				log.Println("发送数据失败", err.Error())
				return err
			}
			//发送后把收集的结果集清空
			res = (res)[0:0] //从0取到0
		}
		time.Sleep(time.Millisecond)
	}
	// 发送残留的值，这里是剩余奇数的情况
	if len(res) > 0 {
		err := stream.Send(&UserScoreResponse{UserInfos: res})
		if err != nil {
			log.Println("发送数据失败", err.Error())
			return err
		}
	}

	return nil
}

// QueryUserScore
// 批量处理
func (u *UserService) QueryUserScore(ctx context.Context, req *UserScoreRequest) (*UserScoreResponse, error) {
	res := make([]*UserInfo, len(req.UserInfos))
	for i := 0; i < len(req.UserInfos); i++ {
		log.Println("userid", req.UserInfos[i].UserId)
		res[i] = &UserInfo{
			UserId:    req.UserInfos[i].UserId,
			UserScore: float32(rand.Intn(100)),
		}
	}
	return &UserScoreResponse{UserInfos: res}, nil
}
func (u *UserService) mustEmbedUnimplementedUserServiceServer() {

}
