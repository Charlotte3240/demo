package services

import (
	"context"
	"log"
)

type OrderService struct {
	
}


func (o *OrderService)NewOrder(ctx context.Context,req *OrderInfo) (*OrderResponse, error){
	log.Println(req.OrderPrice,req.OrderNo,req.OrderId,req.OrderTime,req.OrderUserId)
	return &OrderResponse{
		Status: "1",
		Msg: "创建订单成功",
	},nil

}
func (o *OrderService)mustEmbedUnimplementedOrderServiceServer(){
	log.Fatalln("orderService 未实现的方法")
}