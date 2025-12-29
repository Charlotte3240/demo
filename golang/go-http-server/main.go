package main

import (
	"github.com/gin-gonic/gin"
	"go-http-server/logger"
	"go-http-server/server"
	"go.uber.org/zap"
)

func main() {

	// logger setting
	logger.LoggerSetting(`./output/log.log`)
	zap.L().Info("log init Success !")

	// http serve
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.Use(logger.GinLogger(zap.L()), logger.GinRecovery(zap.L(), true))
	server.Init(r)
	if err := r.Run(`:2333`); err != nil {
		panic(err)
	}
}
