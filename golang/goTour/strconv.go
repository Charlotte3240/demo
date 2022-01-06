package main

import (
	"log"
	"strconv"
)

func main() {
	//字符串转int
	str := "123"

	v, err := strconv.Atoi(str) // array to int
	if err != nil {
		log.Println("str -> int fail", err)
	}
	log.Println(v) // 123

	// int 转字符串
	intV := 123456
	strV := strconv.Itoa(intV) // int to array
	log.Println(strV)          // 123456

	// string 转其他基础类型
	if v, err := strconv.ParseBool(str); err == nil {
		log.Println("str -> bool", v)
	}
	// 转32位浮点型
	if v, err := strconv.ParseFloat(str, 32); err == nil {
		log.Println("str -> Float", v)
	}
	// 转int64 10进制
	if v, err := strconv.ParseInt(str, 10, 64); err == nil {
		log.Println("str -> Float", v)
	}
}
