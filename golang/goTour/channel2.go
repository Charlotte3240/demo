package main

import "fmt"

func main() {
	var ch1 = make(chan int)

	var ch2 = make(chan int)


	go generateIntValue(ch1)
	go square(ch1, ch2)

	//for {
	//	v ,ok := <- ch2
	//	if !ok{break}
	//	fmt.Println(v)
	//}

	// 第二种从通道中取值的方式
	for v := range ch2 {
		fmt.Println(v)
	}
	fmt.Println("end")
}

func generateIntValue(ch chan<- int) {
	// 如果想对这个函数中从通道进行限制，可以对chan关键字进行一个修饰，变成单向通道
	//chan<-


	for i := 0; i < 100; i++ {
		ch <- i
	}
	// 发送完数据，关闭通道
	// 关闭的通道也可以取值，但是不能再继续追加了
	close(ch) // 通道只能关闭一次，关闭一个已经关闭的通道会引发 Panic
	//close(ch)  //panic: close of closed channel
	//ch <- 10   //panic: send on closed channel
}

// 计算平方
func square(ch1 <-chan int, ch2 chan<- int) {
	for {
		v, ok := <-ch1
		if !ok {
			break
		}
		ch2 <- v * v
	}
	close(ch2)
}
