package main

import (
	"gin-tour/file"
	"gin-tour/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"net/http"
	"time"
)

func main() {
	// 初始化日志
	logger.Setting()

	// 路由
	gin.SetMode(gin.DebugMode)
	r := gin.Default()
	r.StaticFile("/favicon.ico", "./favicon.ico")
	r.GET("/", fileHandler)
	r.GET("/hello", helloHandler)
	r.GET("/query", queryHandler)
	r.LoadHTMLFiles("./static/login.html", "./static/index.html")
	r.GET("/from", fromHandler)
	r.POST("/login", loginHandler)
	// 上传文件
	r.POST("/upload", file.Upload)

	// 重定向
	r.GET("/redirect", func(c *gin.Context) {
		//外部重定向
		c.Redirect(301, "https://www.baidu.com")
	})
	// 内部重定向
	r.GET("/redirectInternal", func(c *gin.Context) {
		c.Request.URL.Path = "/redirect" // 修改request path
		r.HandleContext(c)               // 继续处理c 这个context
	})

	// any 请求
	r.Any("/any", func(c *gin.Context) {
		switch c.Request.Method {
		case http.MethodGet:
			zap.L().Info("get request")
			c.JSON(http.StatusOK, gin.H{
				"msg": "get",
			})
			return
		default:
			zap.L().Info(c.Request.Method + "request")
			c.JSON(http.StatusOK, gin.H{
				"msg": "any",
			})
		}
	})

	// no router
	r.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{"msg": "not found path"})
	})

	// 路由组
	userG := r.Group("/user")
	// 也可以在路由组使用中间件
	//userG.Use(authMiddleware(true))
	{
		userG.GET("/info", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"uid":  12345,
				"name": "charlotte",
				"age":  18,
			})
		})
		userG.POST("/updateInfo", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"msg": "success"})
		})
		// 路由组里面也可以嵌套路由组
		// 注意这里的group 要由上一个group 来创建
		settingG := userG.Group("/setting")
		settingG.GET("/notification", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"notification": false,
			})
		})
	}

	// 中间件
	r.GET("middleware", testMiddleWare, func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"msg": "middleware",
		})
	})
	// 全局注册中间件
	r.Use(testMiddleWare)

	r.GET("/movie", movie)

	r.Run(":10010")
}

func authMiddleware(doCheck bool) gin.HandlerFunc {
	// 做一些准备工作
	// 链接数据库等等
	return func(c *gin.Context) {
		// 注意，在中间件中，goroutine不能直接使用c gin.Context,只能使用copy的
		go func(c *gin.Context) {}(c.Copy())
		if doCheck {
			// 做一些校验操作
		} else {
			c.Next()
		}

	}
}

type Movie struct {
	Name string `json:"name"`
	Year string `json:"year"`
}

func movie(c *gin.Context) {
	ret := []Movie{
		{
			Name: "asd",
			Year: "2021",
		},
		{
			Name: "qwe",
			Year: "2022",
		},
	}
	c.JSON(http.StatusOK, ret)
}

func testMiddleWare(c *gin.Context) {
	zap.L().Info("test middleware")
	start := time.Now()
	// 调用后续的处理函数
	c.Next()
	// 阻止调用后续的处理函数, abort 和 next 只能执行一个
	//c.AbortWithStatus(http.StatusBadRequest)
	zap.L().Info("后续处理逻辑已经执行完了", zap.Duration("cost", time.Since(start)))
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
