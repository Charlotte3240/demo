package main

import (
	"log"
	"sync"
	"sync/atomic"
)

// 假设模型分配比例如下
/*
	A : 7
	B : 3
*/
var AProp = 2.0
var BProp = 8.0

var Scale = float64(AProp) / (float64(AProp) + float64(BProp))

var wg sync.WaitGroup

var aCount int64 = 0
var bCount int64 = 0

func main() {

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			AllocationStrategy()
			wg.Done()
		}()
	}
	wg.Wait()
	log.Println(aCount, bCount)

}

func AllocationStrategy() {
	if float64(atomic.LoadInt64(&aCount))/float64(atomic.LoadInt64(&bCount)+atomic.LoadInt64(&aCount)) <= Scale {
		Aop()
	} else {
		Bop()
	}
}

func Aop() {
	atomic.AddInt64(&aCount, 1)
	log.Println("A")
}

func Bop() {
	atomic.AddInt64(&bCount, 1)
	log.Println("B")
}

//MARK: -根据channel 进行实现

// var ACh = make(chan int, 1)
// var BCh = make(chan int)

// func AllocationStrategy() {
// 	select {
// 	case ACh <- 0:
// 		Aop()
// 	case BCh <- 0:
// 		Bop()
// 	}
// }

// func Aop() {
// 	log.Println("A")
// 	atomic.AddInt64(&aCount, 1)
// 	<-BCh
// }

// func Bop() {
// 	log.Println("B")
// 	atomic.AddInt64(&bCount, 1)
// 	<-ACh
// }
