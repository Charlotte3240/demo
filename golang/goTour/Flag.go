package main

import (
	"flag"
	"fmt"
	"log"
	"os"
)

var host string
var port int

func main() {
	paramFromOsArgs()

	flag.Parse()
	fmt.Println(host, port)
	//获取flag后面的参数
	fmt.Println(flag.Args()) // [111 222 333]
}

// paramFromOsArgs  从标准命令行接收命令，第0个参数是path
func paramFromOsArgs() {
	if len(os.Args) > 0 {
		for i, v := range os.Args {
			if i > 0 {
				log.Println(i, v)
			}
		}
	}
}

func init() { // 每个文件会自动执行的函数
	// go run Flag.go -host "192.168.1.1" -port 1234 111 222 333
	// flag 参数一定要放在前面
	flag.StringVar(&host, "host", "127.0.0.1", "输入host地址")
	flag.IntVar(&port, "port", 3306, "输入端口号")
}
