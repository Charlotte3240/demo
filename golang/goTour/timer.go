package main

import (
	"fmt"
	"time"
)

func main() {
	timer2 := time.NewTimer(time.Second)
	finishWait := make(chan interface{}, 1)
	go func() {
		defer fmt.Printf("退出了协程")
		for {
			select {
			case <-timer2.C:
				fmt.Println("Timer 2 fired")
			case <-finishWait:
				timer2.Stop()
				return
			}
		}

	}()
	timer2.Stop()
	time.Sleep(time.Second * 3)
	finishWait <- 1
	time.Sleep(time.Second * 10)
}
