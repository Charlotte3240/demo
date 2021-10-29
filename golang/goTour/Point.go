package main

import "fmt"

func main() {
	// 指针

	//n := 111
	//p := &n
	//fmt.Println(p)
	//n2 := *p
	//fmt.Println(n2)

	//var a *int
	//*a =1// 这里由于，只声明了一个int 指针，但是没有地址，所以是一个空指针，这里会在运行时出问题
	a := new(string)// 分配一个内存地址，注意：这里只是一个地址，-> 一个（T）指针类型
	*a = "100"
	fmt.Println(*a)

	// make ,new 用于内存分配
	// make 和 new的区别是，只用于 slice map chain 的内存创建，而且返回的类型就是他们本身，不是内存地址
	// new 用于基本数据类型（int string 等）的内存创建，返回的是内存地址


	i1 := 2333
	modify1(i1)
	fmt.Println(i1)
	modify2(&i1)
	fmt.Println(i1)
}

// 值类型传递，基础数据类型不改变原值，引用类型会改变
func modify1(i int){
	i = 100
}
// 指针传值
func modify2(i *int){
	*i = 200
}