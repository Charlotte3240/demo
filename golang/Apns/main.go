package main

import (
	"apns/logger"
	"apns/services"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

const (
	TeamID = "M29Y8582X5"
	KeyID  = "K7AYSC553X"
)

func main() {

	// logger setting
	logger.LoggerSetting(`./output/log.log`)
	zap.L().Info("log init Success !")
	// new apns service
	services.StartService(TeamID, KeyID)
	// http
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.POST("/register", services.RegisterDevice)
	r.POST("/push", services.PushSingleNotification)
	r.POST("/pushMultiple", services.PushMultiple)
	r.Use(logger.GinLogger(zap.L()), logger.GinRecovery(zap.L(), true))
	if err := r.Run(`:23333`); err != nil {
		panic(err)
	}
}
