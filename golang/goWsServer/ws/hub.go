package ws

type Hub struct {
	clients      map[*Client]bool //所有注册好的client
	registerCh   chan *Client     //注册channel
	unregisterCh chan *Client     // 注销channel
}

// NewHub 构造函数
func NewHub() *Hub {
	return &Hub{
		clients:      make(map[*Client]bool),
		registerCh:   make(chan *Client),
		unregisterCh: make(chan *Client),
	}
}

// Run 对 注册，注销，client集合 的channel，进行收发操作
func (h *Hub) Run() {
	for {
		select {
		case client := <-h.registerCh:
			//log.Println("收到注册channel")
			h.clients[client] = true
		case client := <-h.unregisterCh:
			//log.Println("收到注销channel")
			if _ ,ok := h.clients[client]; ok{
				delete(h.clients, client)
				close(client.send)
			}
		}
	}

}
