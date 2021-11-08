package services

import (
	"context"
	"log"
)

type HelloService struct {}



func (s *HelloService) mustEmbedUnimplementedHelloWorldServer() {
	panic("implement me")

}

func (s *HelloService) HelloRPC(ctx context.Context, req *SayHelloRequest) (*HelloReplay, error) {
	// 获取传递过来的参数
	log.Println(req.Name)
	return &HelloReplay{Message: req.Name},nil
}
