package main

import (
	"fmt"
	"sync"
)

var value = 0

var wg sync.WaitGroup
var lock sync.Mutex // 互斥锁


func main() {
	// go语言中的锁
	wg.Add(2)
	go modify()
	go modify()
	wg.Wait()
	fmt.Println(value)
}

func modify() {
	lock.Lock()
	for i := 0; i < 1000; i++ {
		value += 1
	}
	lock.Unlock()
	wg.Done()
}
