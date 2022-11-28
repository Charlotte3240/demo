package main

import (
	"errors"
	"log"
	"time"
)

func main() {
	err := timeout(costLongTimeWork)
	if err != nil {
		//log.Println(debug.Stack()) // 打印堆栈信息
		log.Panicln(err)
		return
	}
	log.Println("normal callback")
}

func costLongTimeWork(done chan struct{}) {
	defer func() {
		done <- struct{}{}
	}()
	// 模拟耗时操作
	time.Sleep(10 * time.Millisecond)
}

func timeout(f func(chan struct{})) error {
	done := make(chan struct{}, 1)
	go f(done)
	select {
	case <-done:
		return nil
	case <-time.After(time.Millisecond * 50):
		return errors.New("timeout error")
	}
}
