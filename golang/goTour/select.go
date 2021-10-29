package main

import "fmt"

func main() {
	// select 多路复用
	// 和switch 语法类似， 每次只执行一个case
	// 如果所有的case都满足，随机选择一个进行执行
	// 如果所有都都不满足，就走default

	var ch1 = make(chan int, 10)

	for i := 0; i < 10; i++ {
		select {
		case x := <-ch1:
			fmt.Println(x)
		case ch1 <- i: //这里设置的缓冲区为1，所以写如一个，就会阻塞，下次循环时就只能读。如果缓冲区设置的大了，那么有可能是一直在写入，没有输出出来
		default:
			fmt.Println("没有满足的case")
		}
	}
}
