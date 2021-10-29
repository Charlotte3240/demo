package main

import (
	"math/rand"
	"sync"
	"time"
)

var (
	wg sync.WaitGroup
)

func main() {
	//设置随机种子
	rand.Seed(time.Now().UnixMicro())

	jobChan := make(chan int64, 30)
	resultChan := make(chan int64, 30)

	wg.Add(1)
	//起一个异步生成随机数塞到job chan
	go generateRandomValue(jobChan)

	//起24个异步从 jobchan 取数进行计算
	for i := 0; i < 24; i++ {
		wg.Add(1)
		go calc(jobChan, resultChan)
	}

	wg.Wait()
}

func generateRandomValue(jobCh chan<- int64) {
	for i := 0; i < 100; i++ {
		v := rand.Int63n(1000)
		jobCh <- v
	}
	close(jobCh)
	wg.Done()
}

func calc(jobCh <-chan int64, resultCh chan<- int64) {
	for job := range jobCh {

	}
}
