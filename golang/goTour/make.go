package main

import "fmt"

// make
func main() {
	// 1. 使用make 来创建切片
	// make(类型,长度,空间)
	s1 := make([]int,3,5)
	fmt.Println(s1,s1[2], len(s1), cap(s1))
	// 使用make 创建的切片不可能是nil，可能会是一个empty
	s2 := make([]int,0,0)
	fmt.Println(s2, len(s2), cap(s2),s2 == nil)
}