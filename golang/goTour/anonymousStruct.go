package main

import "fmt"

type Demo struct {
	// 不用起字段名称 -> 匿名结构体 没有什么卵用
	string
	//string 字段的类型不能重复，就是一种类型只能出现一次
}

func main() {
	// 匿名结构体
	//d1 := Demo{"123","456"}
	d1 := Demo{"123"}
	fmt.Printf("%#v %#v \n",d1,d1.string)
}