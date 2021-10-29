package main

import (
	"fmt"
)

// interface 基本上等同于swift中的protocol

// 使用值接收者和指针接收者来实现接口的区别：


// 空接口可以接收任意类型的值，一般不需要提前定义
// 空接口的作用：
// 1. 作为函数的参数，可以传递任意类型的变量
// 2. 空接口可以作为 map 或者slice中的元素（这时候就和swift中的字典相同 map[string]interface{} = [string : Any]）
// 3.

type nullInterface interface {
	
}


func main() {
	var socket WebSocket = NativeWebsocket{}
	socket.connect()

	disconnectWebsocket(socket)
	disconnectWebsocket(StarScream{})

	var net Internet = NativeWebsocket{}
	net.post()
	net.connect()
	net.disconnect()

	var i interface{} // 定义一个空接口变量
	i = 10
	fmt.Println(i)
	i = "charlotte"
	fmt.Println(i)

	i = nil
	fmt.Println(i)

	var dic = make(map[string]interface{} , 10)// [String : Any]
	dic["title"] = "首页"
	dic["leftMargin"] = 100
	dic["hiddenNav"] = false
	fmt.Printf("%#v\n",dic)

	var dic2 = make(map[interface{}]interface{},10) // [Any : Any]
	dic2[111] = "title"
	dic2["navLeftHidden"] = true
	fmt.Println(dic2)

	// 类型断言
	//interface.(想判断的类型)
	//res := i.(int) // 类型断言可能会引发 Panic
	//fmt.Println(res,ok)
	// 带上ok
	res ,ok := i.(int)
	if ok{
		//res 是正常的字符串
		fmt.Println("断言正确的类型:",res)
	}else {
		// res 是空的字符串
		fmt.Println("断言错误的类型，所以给一个零值",res)
	}

	// 使用switch 进行类型断言
	switch t := i.(type) {
	case string:
		fmt.Println("string 类型",t)
	case int:
		fmt.Println("int 类型",t)
	//case nil:
	//	fmt.Println("nil 类型",t)
	default:
		fmt.Println("default",t)
	}

}

func disconnectWebsocket(wss WebSocket){
	wss.disconnect()
}

// 接口的嵌套
type Internet interface {
	WebSocket
	Http
}

type Http interface {
	post()
}


type WebSocket interface {
	connect()
	disconnect()
	//sendMsg(msg []byte)
	//sendData(data []byte)
	//sendPing()
	//sendPong()
	//dealWithPong()

}
type NativeWebsocket struct {
}

func (n NativeWebsocket) connect() {
	fmt.Println("原生wss connect")
}
func (n NativeWebsocket)disconnect(){
	fmt.Println("原生wss disconnect")
}

func (n NativeWebsocket)post(){
	fmt.Println("post call")
}


type StarScream struct {
}

func (s StarScream) connect() {
	fmt.Println("starscream wss connect")
}

func (s StarScream)disconnect(){
	fmt.Println("starscream disconnect")
}
