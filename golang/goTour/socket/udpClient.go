package main

import (
	"bufio"
	"fmt"
	"net"
	"os"
	"strings"
)

func main() {

	lAddr := &net.UDPAddr{
		IP:   net.IPv4(127, 0, 0, 1),
		Port: 2333,
	}

	rAddr := &net.UDPAddr{
		IP:   net.IPv4(127, 0, 0, 1),
		Port: 8082,
	}

	conn, err := net.DialUDP("udp", lAddr, rAddr)
	if err != nil {
		fmt.Println("dial error :", err)
		return
	}
	defer conn.Close()

	input := bufio.NewReader(os.Stdin)
	for {
		// send
		inputStr,_ := input.ReadString('\n')
		inputStr = strings.TrimSpace(inputStr)

		n,err := conn.Write([]byte(inputStr))
		if err != nil{
			fmt.Println("write error: ",err)
		}
		fmt.Println("write bytes count :",n)

		// read
		var buf [1024]byte
		n,addr,err := conn.ReadFromUDP(buf[:])
		if err != nil{
			fmt.Println("read form udp addr: error :",addr.IP,err)
		}
		receStr := string(buf[:n])
		fmt.Printf("receive form:%v msg:%v \n",addr.IP,receStr)

	}

}
