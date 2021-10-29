package main

import (
	"fmt"
	"strconv"
)

func main() {
	var (
		a = 2
		b = 6
		c = 7
		s = "123"
	)

	fmt.Println(a+b)
	fmt.Println(c/a)
	fmt.Println(c%a)
	// 这里产生报错，只有类型相同才可以进行比较
	//fmt.Println(a == s)
	// int 可以转成string， 但是string 不能直接转int
	fmt.Println(string(a) == s)
	// 转成了int64
	//sIntValue ,err := strconv.ParseInt(s,10,64)
	// 转成了int
	sIntValue ,_ := strconv.Atoi(s)
	fmt.Println(a == sIntValue)

	fmt.Println(5>>1<<1)
}
