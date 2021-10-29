package main

import "fmt"

// channel  是在不同的goroutine之间通信的管道
// 是一个类似队列的 先进先出的
// channel 是一种引用类型
func main1() {
	// 1. 声明  var 变量名 chan 产里面传递的类型
	// var chanName chan int

	// 引用类型，声明就是一个nil
	var ch1 chan []int

	//slice map chan 这三个都需要make来进行初始化
	// make(chan []int , 缓冲区的大小(可选的))
	ch1 = make(chan []int, 10)

	// channel 有三种操作， send receive close

	fmt.Println(ch1)
}

func main() {
	// 缓冲区大小有值  -> 有缓冲通道，相反没有 -> 无缓冲通道
	// 无缓冲区的通道又称为 同步通道
	ch1 := make(chan int, 2)
	ch1 <- 10
	x := <-ch1
	fmt.Println(x)

	// 可以通过 len() 获取通道中 元素的数量
	// 通过cap() 获取通道的容量
	ch1 <- 20
	ch1 <- 30
	for {
		if len(ch1) == 0 {
			break
		}
		fmt.Println(<-ch1)
	}

	count := len(ch1)
	cap := cap(ch1)
	fmt.Println(count, cap) // 1 1
	defer close(ch1)
}
