package main

import (
	"bytes"
	"github.com/gin-gonic/gin"
	"io"
	"log"
	"net/http"
	"os/exec"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	r.POST("/docSync", syncDoc)

	if err := r.Run(`:2333`); err != nil {
		panic(err)
	}
}

func syncDoc(c *gin.Context) {
	// log request body
	data, err := c.GetRawData()
	if err != nil {
		log.Println(err.Error())
	}
	log.Printf("data: %v\n", string(data))
	c.Request.Body = io.NopCloser(bytes.NewBuffer(data))
	defer c.Request.Body.Close()

	c.JSON(http.StatusOK, nil)

	executeSync()
}

func executeSync() {
	cmd := `cd /etc/alist/temp/hc-doc
git pull
`
	c := exec.Command("bash", "-c", cmd)
	// 此处是windows版本
	// c := exec.Command("cmd", "/C", cmd)
	output, err := c.CombinedOutput()
	if err != nil {
		log.Println("execute shell fail :", err)
		return
	}
	log.Println("execute shell res :", string(output))
}
