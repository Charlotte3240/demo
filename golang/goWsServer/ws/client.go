package ws

import (
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"time"
)

var upgrade = websocket.Upgrader{
	WriteBufferSize: 10240,
	ReadBufferSize:  10240,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

const (
	writeWait = time.Second * 10

	pongWait = time.Second * 60

	pingPeriod = (pongWait * 9) / 10

	maxMessageSize = 20 * 1024 //20kb

)

type Client struct {
	hub  *Hub            // 客户端用来访问所有集合的总线
	conn *websocket.Conn // 客户端的链接对象
	send chan []byte     // 发送给客户端channel
}

func ServeWs(hub *Hub, w http.ResponseWriter, r *http.Request) error {
	// 创建链接
	conn, err := upgrade.Upgrade(w, r, nil)
	if err != nil {
		return err
	}
	// 创建客户端
	client := &Client{hub: hub, conn: conn, send: make(chan []byte, 256)}

	// 把client 塞入 hub register中、
	client.hub.registerCh <- client

	// 死循环读取消息
	go client.readPump()

	// 死循环发送消息
	go client.writePump()

	// 发送connect 消息
	client.send <- []byte("connectSuccess")

	return nil
}
func (c *Client)writePump(){
	// 从send channel 中读取，发送给客户端
	ticker := time.NewTicker(pingPeriod)
	defer func() {
		ticker.Stop()
		c.conn.Close()
	}()
	for {
		select {
		case value, ok := <-c.send:
			if err := c.conn.SetWriteDeadline(time.Now().Add(writeWait)); err != nil {
				log.Println("超时写入", err.Error())
				return
			}
			if !ok {
				// 通道不能读取,发送关闭 frame
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			w,err := c.conn.NextWriter(websocket.TextMessage)
			if err != nil{
				log.Println("创建writer 错误",err.Error())
				return
			}
			w.Write(value)

			n := len(c.send)// 防止通道中还有消息，直接都发送出去
			for i := 0; i < n; i++ {
				w.Write(<-c.send)
			}
			// 关闭writer
			if err := w.Close(); err != nil {
				log.Println("关闭write 失败",err.Error())
				return
			}
		case <-ticker.C: //定时发送ping
			//log.Println("发送ping message")
			c.conn.SetWriteDeadline(time.Now().Add(writeWait))
			if err := c.conn.WriteMessage(websocket.PingMessage, nil); err != nil {
				log.Println("发送ping错误",err.Error())
				return
			}
		}
	}
}

func (c *Client)readPump(){
	// 不读取的时候关闭ws连接,并且发送给 unregister channel
	defer func() {
		c.hub.unregisterCh <- c
		c.conn.Close()
	}()

	c.conn.SetReadLimit(maxMessageSize)
	if err := c.conn.SetReadDeadline(time.Now().Add(pongWait)); err != nil {
		log.Println("超时读取，关闭链接")
		return
	}
	c.conn.SetPongHandler(func(appdata string) error {
		c.conn.SetReadDeadline(time.Now().Add(pongWait))
		//log.Println("pong handler",appdata)
		return nil
	})
	// 从connect 中 读取 buf ，来处理消息
	// 需要发送时，塞入client的send channel
	for {
		_, data, err := c.conn.ReadMessage()
		if err != nil {
			// 意外关闭错误
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Println("意外关闭", err.Error())
			}
			return
			log.Println("读消息错误", err.Error())
		}
		//log.Println("消息种类：", msgType, "message:", string(data))
		//TODO：- 返回消息replay， 后续加上业务逻辑，向一个 chan map[client]string 中发送消息
		c.send <- []byte(string(data) + "replay")
	}
}


func processBiz(){

}
