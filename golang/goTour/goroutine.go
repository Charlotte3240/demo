package main

import (
	"fmt"
	"sync"
	"time"
)
var wg = sync.WaitGroup{}

func main() {
	// go 语言中，还支持匿名函数 协程
	for i := 0; i < 10000; i++ {
		wg.Add(1)
		go func (i int){
			fmt.Println("hello",i)
			wg.Done()
		}(i)

		// 这样子引用的i 有可能很多次都是同一个
		//go func (){
		//	fmt.Println("hello",i)
		//	wg.Done()
		//}()
	}
	wg.Wait()
}


// goroutine 协程
func main1() {


	//wg.Add(1) // 计数加1

	for i := 0; i < 10000; i++ {
		go hello(i)
		wg.Add(1)
	}

	//go hello() // 函数调用前，加上go，开启一个goroutine 调用
	fmt.Println("main ",time.Now())
	//time.Sleep(20) // 直接给定一个数字，默认单位是纳秒
	//time.Sleep(time.Second) // 这是1秒
	wg.Wait() // 等计数归零才执行后面的代码，异步转成同步
	fmt.Println("wait after")
}

func hello(count int){
	fmt.Println("hello goroutine",time.Now()," c",count )
	wg.Done() // 计数器减1
}

