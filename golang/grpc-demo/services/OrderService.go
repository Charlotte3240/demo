package services

import (
	"context"
	"log"
)

type OrderService struct {
	
}


func (o *OrderService)NewOrder(ctx context.Context,request *OrderRequest) (*OrderResponse, error){
	req := request.OrderInfo
	log.Println(req.OrderPrice,req.OrderNo,req.OrderId,req.OrderTime,req.OrderUserId)

	for _, detail := range req.OrderDetails {
		log.Println("mainOrderId",detail.OrderNo,"detailId:",detail.OrderDetailId,"detailNo:",detail.OrderDetailNo,"num:",detail.OrderNum,"type:",detail.OrderType)
	}


	return &OrderResponse{
		Status: "1",
		Msg: "创建订单成功",
	},nil

}
func (o *OrderService)mustEmbedUnimplementedOrderServiceServer(){
	log.Fatalln("orderService 未实现的方法")
}