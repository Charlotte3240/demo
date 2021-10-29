package main

import (
	"bufio"
	"fmt"
	"net"
)

var clients []interface{}

func main() {

	initServer()
}

// initServer
func initServer() {
	lis, err := net.Listen("tcp", "localhost:8082")
	if err != nil {
		fmt.Printf("listen error :%#v \n", err)
	}

	for {
		connect, err := lis.Accept()
		if err != nil {
			fmt.Printf("connect error :%#v \n", err)
			// 如果这个链接错误，就继续循环等下一个链接来
			continue
		}
		go dealConn(connect)
	}
}

func dealConn(conn net.Conn) {
	defer conn.Close()
	for {
		// 从链接中读取数据
		reader := bufio.NewReader(conn)
		var buf [128]byte
		n,err := reader.Read(buf[:])
		if err != nil{
			fmt.Printf("read from conn error:%#v\n",err)
			break
		}
		// 转成字符串
		recv := string(buf[:n])
		fmt.Println("receive :",recv)

		if recv == "hello world"{
			conn.Write([]byte("hello replay"))
		}else {
			conn.Write([]byte("ok"))
		}
	}
}
