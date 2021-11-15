package main

import (
	"github.com/gorilla/websocket"
	"log"
	. "nsqk.com/websocket/utilities"
	"sync"
	"time"
)

var wg sync.WaitGroup

// 用来测试websocket的客户端
func main() {
	for i := 0; i < 10000; i++ {
		wc := NewWSClientManager("ws://localhost:8080/ws", 10)
		startAndReconnect(wc)
	}
	wg.Add(1)
	wg.Wait()
}

type WSClientManager struct {
	conn      *websocket.Conn // connect objc
	addr      *string         // server address  string
	sendMsgCH chan string     // send message channel
	recvMsgCH chan string     // receive message channel
	isAlive   bool            // client connect is alive status
	timeout   int             // client connecting timeout num
}

// NewWSClientManager create a client manager struct
//
// use for dial server test
func NewWSClientManager(addr string, timeout int) *WSClientManager {
	var conn *websocket.Conn
	return &WSClientManager{
		conn:      conn,
		addr:      &addr,
		sendMsgCH: make(chan string),
		recvMsgCH: make(chan string),
		isAlive:   false,
		timeout:   timeout,
	}
}

func (wc *WSClientManager) readMsg() {
	for {
		if wc.conn == nil {
			return
		}
		msgType, data, err := wc.conn.ReadMessage()
		if err != nil {
			log.Println("读消息失败", err.Error())
			wc.isAlive = false
			return
		}
		log.Println("消息类型:", msgType, "收到的消息:", Bytes2str(data))
	}
}

func (wc *WSClientManager) sendMsg() {
	ticker := time.NewTicker(time.Second * 3)
	pingTicker := time.NewTicker(time.Second * 59)
	defer func() {
		ticker.Stop()
		wc.conn.Close()
		log.Println("退出了循环")
	}()
	for {
		select {
		case <-ticker.C:
			// 定时向 sendCH 塞入消息
			go func() { wc.sendMsgCH <- "time up" }()
		case <-pingTicker.C:
			// 处理ping
			go func() { wc.sendMsgCH <- "ping" }()
		case msg := <-wc.sendMsgCH:
			if msg == "ping"{
				wc.conn.WriteMessage(websocket.PingMessage, nil)
			}else {
				wc.conn.WriteMessage(websocket.TextMessage, Str2bytes(msg))
			}

		}
	}
}

func (wc *WSClientManager) dial() {
	//TODO:- 这里没有设置header
	var err error
	wc.conn, _, err = websocket.DefaultDialer.Dial(*wc.addr, nil)
	if err != nil {
		log.Println("dial error", err.Error())
		return
	}
	wc.isAlive = true
	log.Println("链接成功")

}
func startAndReconnect(wc *WSClientManager) {
	//for {
	if wc.isAlive == false {
		wc.dial()
		go wc.readMsg()
		go wc.sendMsg()
	}
	// 过1s后重连
	//time.Sleep(time.Second)
	//}

}
