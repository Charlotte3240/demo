package main

import (
	"fmt"
	"gin-tour/logger"
	"io/ioutil"
	"net/http"

	"go.uber.org/zap"
)

func main() {

	// 初始化日志
	logger.LoggerSetting()
	// http server
	http.HandleFunc("/hello", helloHandler)
	err := http.ListenAndServe(":8082", nil)
	if err != nil {
		zap.L().Fatal("http server error: ", zap.Error(err))
	}
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	d, err := ioutil.ReadFile("./index.html")
	if err != nil {
		zap.L().Error("read index.html file fail", zap.Error(err))
	}

	_, _ = fmt.Fprintf(w, string(d))
	zap.L().Info("hello world")
}
