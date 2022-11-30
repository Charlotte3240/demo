package main

import (
	"log"
	"strconv"
	"sync"
	"time"
)

var flag = false

func main() {
	//1. 初始化cond , 可以传入 mutex 或者 rwmutex
	cond := sync.NewCond(&sync.RWMutex{})

	//2. 确保wait 在broadcast前先执行
	for i := 0; i < 3; i++ {
		go waitFunc("args"+strconv.Itoa(i), cond)
	}
	prepareFunc("args", cond)

	time.Sleep(time.Second * 10)
}

func waitFunc(args string, c *sync.Cond) {
	log.Println("wait: ", args)
	c.L.Lock()
	for !flag { // 用if不行是因为唤醒时不一定符合条件，所以用for 循环判断
		// 调用wait后 会自动释放锁，然后挂起goroutine,当触发signal/broadcast, goroutine被唤醒时 再加锁
		c.Wait()
	}
	log.Println("数据已经准备好了: ", args)
	c.L.Unlock()
}

func prepareFunc(args string, c *sync.Cond) {
	log.Println("prepare: ", args)
	time.Sleep(time.Second * 1)
	c.L.Lock()
	flag = true
	c.L.Unlock()
	log.Println("broadcast all goroutine")
	//c.Broadcast() // 全部唤醒
	for i := 0; i < 3; i++ {
		time.Sleep(time.Second)
		c.Signal() // 唤醒一个
	}
}
