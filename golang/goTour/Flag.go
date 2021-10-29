package main

import (
	"flag"
	"fmt"
)

var host string
var port int

func main() {
	flag.Parse()
	fmt.Println(host,port)
}

func init(){ // 每个文件会自动执行的函数
	flag.StringVar(&host,"host","127.0.0.1","输入host地址")
	flag.IntVar(&port,"port",3306,"输入端口号")
}