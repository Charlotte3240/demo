package main

import (
	"fmt"
	"runtime"
	"time"
)

//func main() {
//
//	go func (){fmt.Println("demo goroutine")}()
//
//	// 上面开启了一个goroutine， main也是一个 所以是2 ， 机器是4核8线程，这里就当成了8个cpu
//	fmt.Println(runtime.NumCPU(),runtime.NumCgoCall(),runtime.NumGoroutine()) // 8 0 2
//
//	time.Sleep(time.Second)
//}

func main() {
	runtime.GOMAXPROCS(10) // 设置占用最大cpu数量
	go a()
	go b()
	time.Sleep(time.Second)
}

func a(){
	for i := 1; i < 1000; i++ {
		fmt.Println("A:", i)
	}
}
func b(){
	for i := 1; i < 1000; i++ {
		fmt.Println("B:", i)
	}
}