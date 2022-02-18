package main

import (
	"gin-tour/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net/http"
)

func main() {
	// 初始化日志
	logger.LoggerSetting()

	// 路由
	gin.SetMode(gin.DebugMode)
	r := gin.Default()
	r.GET("/", fileHandler)
	r.GET("/hello", helloHandler)
	r.GET("/query", queryHandler)
	r.LoadHTMLFiles("./static/login.html", "./static/index.html")
	r.GET("/from", fromHandler)
	r.POST("/login", loginHandler)

	r.Run(":9090")
}

func loginHandler(ctx *gin.Context) {
	u := ctx.PostForm("username")
	p := ctx.PostForm("password")
	s := ctx.DefaultPostForm("sex", "unknown")
	zap.L().Info("login", zap.String("userName", u), zap.String("pwd", p))

	ctx.HTML(http.StatusOK, "index.html", gin.H{"Name": u, "Pwd": p, "Sex": s})
}

func fromHandler(ctx *gin.Context) {
	ctx.HTML(http.StatusOK, "login.html", nil)
}

func queryHandler(ctx *gin.Context) {
	token := ctx.DefaultQuery("token", "no such key from url query param")
	//ctx.Get...
	ctx.JSON(http.StatusOK, gin.H{
		"token": token,
	})

}

func fileHandler(ctx *gin.Context) {
	ctx.File("./static/index.html")
}

func helloHandler(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{
		"msg": "hello world",
	})
}
