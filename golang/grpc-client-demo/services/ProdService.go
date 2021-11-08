package services

import (
	"context"
	"log"
)

type ProdService struct {
}

func (p *ProdService)GetProdDetail(ctx context.Context, req *ProdRequest) (*ProdModel, error){
	log.Println(req.ProdId,req.ProdArea)
	return &ProdModel{
		ProdId: 12,
		ProdName: "黄鹤楼",
		ProdPrice: 19.5,
	},nil
}

func (p *ProdService) GetProdStock(ctx context.Context, req *ProdRequest) (*ProdResponse, error) {
	log.Println(req.ProdId, req.ProdArea)
	var prodRes *ProdResponse

	if req.ProdArea == ProdAreas_drinks {
		prodRes = &ProdResponse{
			ProdStock: 1,
		}
	} else if req.ProdArea == ProdAreas_food{
		prodRes = &ProdResponse{
			ProdStock: 5,
		}
	}else {
		prodRes = &ProdResponse{
			ProdStock: 10,
		}
	}
	return prodRes, nil
}

func (p *ProdService) GetProdStocks(ctx context.Context, req *QuerySize) (*ProdResponseList, error) {
	log.Println(req.Size)
	return &ProdResponseList{Prodres: []*ProdResponse{&ProdResponse{ProdStock: 2333}}}, nil
}
func (p *ProdService) mustEmbedUnimplementedProdServiceServer() {
	log.Fatalln("含有未实现的service")
}
