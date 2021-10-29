package main

import (
	"encoding/base64"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-basic/uuid"
	"net/http"
)

func main() {
	r := gin.Default()
	r.POST("/tts",TTS)
	r.GET("/tts",TTS)
	r.Run(":8080")
}

// Result 这里参数名要大写开头，不然不能反射
type Result struct {
	Status string `json:"status"`
	Msg string `json:"msg"`
	Data string `json:"data"`
	Task_id string `json:"task_id"`
}
func genSuccess(uuid string) Result{
	return  Result{
		Status: "1",
		Msg: "success",
		Data: base64.StdEncoding.EncodeToString([]byte("wav source string")),
		Task_id: uuid,
	}
}

func genFail(uuid string) Result{
	return Result{
		Status: "0",
		Msg: "fail",
		Data: "",
		Task_id: uuid,
	}
}
/*
	{
		"text":"语音合成测试",
		"per":"发音人",
		"project":"项目名称可能会和文本处理有关",
		"pit":"音调",
		"spd":"语速",
		"vol":"音量"
	}
*/
type Param struct {
	Text string `json:"text"`
	Per string `json:"per"`
	Project string `json:"project"`
	Pit string `json:"pit"`
	Spd string `json:"spd"`
	Vol string `json:"vol"`
}



func TTS(c *gin.Context){
	uuidStr := uuid.New()
	// 获取body
	var reqInfo = Param{}
	c.BindJSON(&reqInfo)
	fmt.Println(reqInfo)

	if len(c.DefaultQuery("demo", "")) == 0{
		c.JSON(http.StatusOK,genFail(uuidStr))
	}else {
		c.JSON(http.StatusOK,genSuccess(uuidStr))
	}
}
