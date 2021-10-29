package main

import (
	"fmt"
	"sync"
	"time"
)

var result = 0
var rwlock  sync.RWMutex // 读写互斥锁： 当写时，所有都不能获得锁；当一个goroutine获的读锁时，其他goroutine也能获得读锁
var wg sync.WaitGroup

func main() {

	startTime := time.Now()

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go read()
	}

	for i := 0; i < 10; i++ {
		wg.Add(1)
		go write()
	}
	wg.Wait()
	fmt.Println(result,time.Now().Sub(startTime))
}

func read(){
	rwlock.RLock()
	//rwlock.Lock()
	fmt.Println(result)
	//time.Sleep(time.Millisecond)
	rwlock.RUnlock()
	//rwlock.Unlock()
	wg.Done()
}
func write(){
	rwlock.Lock()
	result += 1
	//time.Sleep(time.Millisecond * 10)
	rwlock.Unlock()
	wg.Done()
}