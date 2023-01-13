package main

import (
	"bufio"
	"bytes"
	"github.com/gin-gonic/gin"
	"hc-doc/sync/cache"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()
	r.POST("/docSync", syncDoc)
	r.GET("/simp", simp)
	r.GET("/reloadSimpRecord", saveRedis)

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
	cmd := `cd ../hc-doc/
git pull
`
	executeSync(cmd)

	cpCmd := `
	cd /root/
	cp -rf ./hc-doc /etc/alist/temp/
	`
	executeSync(cpCmd)

}

// executeSync 执行bash操作
func executeSync(cmd string) {
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

// simp 舔狗日记
func simp(c *gin.Context) {
	// 从redis 里面随机获取一条
	// 链接redis
	simpStr, err := cache.GetValueFromRedis()
	if err != nil {
		log.Println("conn redis fail:", err)
		c.String(http.StatusBadGateway, "")
		return
	}
	// 返回舔狗日记一条数据
	c.String(http.StatusOK, simpStr)
}

func saveRedis(c *gin.Context) {
	if err := saveCommand(); err != nil {
		c.String(http.StatusBadGateway, err.Error())
	}
	c.String(http.StatusOK, "ok")

}

func saveCommand() error {
	//先删除
	err := cache.ClearSimp()
	if err != nil {
		return err
	}

	// 重新添加
	file, err := os.Open("./record.txt")
	if err != nil {
		log.Fatalf(err.Error())
	}
	defer file.Close()

	reader := bufio.NewReader(file)
	for {
		line, err := reader.ReadString('\n') //注意是字符
		if err == io.EOF {
			if len(line) != 0 {
				cache.SetValueToRedis("simp", line)
			}
			break
		}
		if err != nil {
			log.Println("read file failed, err:", err)
			return err
		}
		cache.SetValueToRedis("simp", line)
	}
	return nil
}
