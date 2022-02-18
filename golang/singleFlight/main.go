package main

import (
	"fmt"
	"sync"
	"sync/atomic"
	"time"

	"golang.org/x/sync/singleflight"
)

var count int32 = 0
var wg sync.WaitGroup

// getArticle 获取文章详情
func getArticle(id int) (article string, err error) {
	atomic.AddInt32(&count, 1)
	time.Sleep(time.Duration(count) * time.Millisecond)
	return fmt.Sprintf("Article %d", id), nil
}

func singleFlightGetArticle(sg *singleflight.Group, id int) (article string, err error) {
	value, err, _ := sg.Do(fmt.Sprintf("%d", id), func() (interface{}, error) {
		return getArticle(id)
	})
	// fmt.Println("is shared:", shared)
	return value.(string), err

}

func main() {
	start := time.Now()
	sg := new(singleflight.Group)
	fmt.Println(sg)

	for i := 0; i < 1000; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			a, err := singleFlightGetArticle(sg, 36)
			// a, err := getArticle(36)
			if err != nil {
				panic(err)
			}
			fmt.Println(a)
		}()
	}
	wg.Wait()
	fmt.Println("耗时:", time.Now().Sub(start))
}
