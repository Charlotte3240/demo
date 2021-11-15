package ws

import (
	"github.com/gin-gonic/gin"
	"log"
	//_ "net/http/pprof" //性能监控
)

// 初始化总线
var hub = NewHub()

// StartWebServer 启动web server
func StartWebServer(){
	// 性能检测代码
	//go func() {
	//	log.Println(http.ListenAndServe("localhost:9999", nil))
	//}()

	go hub.Run()
	// TODO：- 上线请打开下面的注释
	//gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.GET("/ws",wsHandler)
	r.Run(":8080")
}

// ws handler
func wsHandler(c *gin.Context){
	// upgrade 到wss
	err := ServeWs(hub,c.Writer , c.Request)
	if err != nil{
		log.Println("upgrade 错误",c.Request.URL.String(),err.Error())
	}
}

