package server

import (
	"bytes"
	"fmt"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"io"
	"net/http"
	"strings"
)

func Init(r *gin.Engine) {
	// 跨域处理
	r.Use(cors.Default())

	r.POST("paramsTest", parmaTestHandler)
}

func parmaTestHandler(c *gin.Context) {
	// 1. 把 body 读出来
	bodyBytes, _ := io.ReadAll(c.Request.Body)
	c.Request.Body = io.NopCloser(bytes.NewBuffer(bodyBytes)) // 放回去，Gin 后续还能用

	// 2. 组装要返回的内容
	var sb strings.Builder
	sb.WriteString("=== Headers ===\n")
	for k, vv := range c.Request.Header {
		sb.WriteString(fmt.Sprintf("%s: %s\n", k, strings.Join(vv, "; ")))
	}
	sb.WriteString("\n=== Body ===\n")
	sb.Write(bodyBytes)

	// 3. 返回 200，纯文本
	c.Data(http.StatusOK, "text/plain; charset=utf-8", []byte(sb.String()))

}
