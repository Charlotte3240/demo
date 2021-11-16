package main

import (
	. "nsqk.com/log/logger"
	"sync"
)

var wg sync.WaitGroup

func main() {
	for i := 0; i < 1; i++ {
		wg.Add(1)
		go func() {
			// logger example
			Example()
			wg.Done()
		}()
	}
	wg.Wait()
}

