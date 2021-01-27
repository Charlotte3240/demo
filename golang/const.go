package main

import "fmt"

const (
	Unknown = 0
	Female = 1
	Male = 2
)


const (
	x = iota
	y = iota
	z = iota
)


const (
	a = iota
	b
	c
	d = "ha"
	e
	f = 100
	g
	h = iota
	i
)

const(
	j = 1<<iota//1<<0
	k = 3<<iota//3<<1 = 3*2
	l// 3<<2 = 3*2^2
	m// 3<<3 = 3*2^3
	// m<<n == m*(2^n)
)

func main() {

	fmt.Println(a,b,c,d,e,f,g,h,i)

	fmt.Println(x,y,z)

	fmt.Println(j,k,l,m)

	var jr = 123
	jr += 1
	fmt.Println(jr)

	var message = "hello world"

	var key = "2333"

	fmt.Println("encode start")

	var encodeStr = strByXOR(message,key)
	fmt.Println(encodeStr)

	var decodeStr = strByXOR(encodeStr,key)
	fmt.Println(decodeStr)

}


func strByXOR(message string,keywords string) string{
	messageLen := len(message)
	keywordsLen := len(keywords)

	result := ""

	for i := 0; i < messageLen; i++ {
		result += string(message[i] ^ keywords[i%keywordsLen])
	}
	return result
}
