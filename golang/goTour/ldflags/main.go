package main

import (
	"fmt"
	"ldflagDemo/conf"
)

// 这样子build 可以传入参数给name
// go build -o ss -ldflags="-X ldflagDemo/conf.Name=charlotte -X ldflagDemo/conf.Sex=male" main.go

// ldflags -s -w 去掉符号表和调试信息，可以减少包大小的20%

func main() {

	fmt.Println(conf.Name, conf.Sex)
}
