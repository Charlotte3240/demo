package main

import (
	"fmt"
	"sync"
)

// dispatchOnece 类似的， 线程安全的

var (
	dispatchOnce sync.Once
	result = 0
	wg sync.WaitGroup
)
func main() {
	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go modify()
	}
	wg.Wait()
	fmt.Println(result)
}


func modify(){
	// 下面两种方式都可以，可以使用匿名函数，或者引用这个函数名称
	//dispatchOnce.Do(initEnv)
	dispatchOnce.Do(func() {
		result += 1
	})
	wg.Done()
}

func initEnv(){
	result += 1
}