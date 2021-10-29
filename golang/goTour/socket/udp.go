package main

import (
	"fmt"
	"net"
)

// udp server
func main() {
	// 1. listen
	conn, err := net.ListenUDP("udp", &net.UDPAddr{
		IP:   net.IPv4(127, 0, 0, 1),
		Port: 8082,
	})
	if err != nil {
		fmt.Println("listen error :", err)
		return
	}
	defer conn.Close()

	for {
		// receive msg
		var buf [1024]byte
		n, addr, err := conn.ReadFromUDP(buf[:])
		if err != nil {
			fmt.Println("read buf err:", err)
			return
		}
		receStr := string(buf[:n])
		fmt.Println(addr, receStr)

		// send msg
		_, err = conn.WriteToUDP(buf[:n], addr)
		if err != nil {
			fmt.Println("write buf addr: err:", addr.IP, err)
			return
		}

	}

}
