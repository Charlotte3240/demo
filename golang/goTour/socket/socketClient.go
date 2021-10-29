package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"
)

func main() {
	// 1.建立链接
	conn,err := net.Dial("tcp","localhost:8082")
	if err != nil{
		fmt.Printf("connect error :%#v \n",err)
		return
	}
	// 发送数据
	//sendMsg(conn,"hello world")

	// 接收数据
	input := bufio.NewReader(os.Stdin)
	for {
		// 从命令行输入发送
		// 回车符截断
		inputStr ,err :=  input.ReadString('\n')
		if err != nil{
			fmt.Println("input str error :",err)
		}
		// 去除空格
		inputStr = strings.TrimSpace(inputStr)

		// 退出程序
		if inputStr == "exit"{
			return
		}

		// 发送
		sendMsg(conn,inputStr)

		// 接收
		var buf [1024]byte
		n, err := conn.Read(buf[:])
		if err != nil {
			fmt.Printf("read failed, err:%v\n", err)
			return
		}
		fmt.Println("收到服务端回复：", string(buf[:n]))

	}
}


func sendMsg(conn net.Conn,msg string){
	n,err := conn.Write([]byte(msg))
	if err != nil{
		fmt.Printf("send msg error :%#v \n",err)
	}
	fmt.Println("send bytes n:",n)
}