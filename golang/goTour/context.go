package main

import (
	"context"
	"fmt"
	"log"
	"time"
)

func main() {
	//withCancel()
	// deadline  和 timeout 效果是一样的，只是参数传递不同
	// deadline 传递的是一个时间节点，timeout 传递的是一个时间长度
	//withDeadline()
	//withTimeout()

	withValue()

	// 利用context 进行超时处理，cancel处理
	/*
		context 进行传递时，作为函数的第一个参数
		以参数形式传递，不是传递指针
		不要传递nil，如果不知道传递什么，就传递一个context.TODO()
		context 是线程安全的
		value 方法应该传递请求域的必要数据，不要来传递可选参数
	*/

}

func withValue() {
	// 创建一个父 context
	pCtx, cancel := context.WithCancel(context.Background())

	// with value 的意义是带上 key value 绑定在父context上，要想取消这个withValue创建的，需要取消父 context
	ctx := context.WithValue(pCtx, "key", "value")
	findValue(ctx, "key")
	findValue(ctx, "key2")

	go func() {
		for {
			select {
			case <-ctx.Done():
				log.Println(ctx.Err())// 这里pCtx取消后，ctx也被cancel了
				return
			}
		}
	}()
	time.Sleep(1 * time.Second)
	cancel()
	time.Sleep(10 * time.Second)

}

func findValue(ctx context.Context, key string) {
	if v := ctx.Value(key); v != nil {
		log.Println("found value is ", v)
	} else {
		log.Printf("not found this key {%v} value \n", key)
	}
}

func withTimeout() {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*4)
	defer cancel()
	go worker(ctx)
	time.Sleep(2 * time.Second)
	cancel()

	time.Sleep(10 * time.Second)

}

func worker(ctx context.Context) {
	for {
		// 这里假设做了一些耗时的操作
		time.Sleep(time.Millisecond * 30)
		select {
		case <-ctx.Done():
			log.Println(ctx.Err())
			return
		}
	}
}

func withDeadline() {
	// deadline 是50毫秒
	ctx, cancel := context.WithDeadline(context.Background(), time.Now().Add(time.Millisecond*50))
	defer cancel()
	for {
		select {
		case <-ctx.Done():
			log.Println(ctx.Err()) // context deadline exceeded
			if ctx.Err() == context.DeadlineExceeded {
				// deadline
				log.Println("deadline")
				return
			}
			if ctx.Err() == context.Canceled {
				// cancel
				log.Println("canceled")
				return
			}
		case <-time.After(time.Millisecond * 10):
			fmt.Println("overslept")
			//cancel() // 这里10毫秒的时候调用了cancel
		}
	}

}

func withCancel() {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	for n := range gen(ctx) {
		log.Println(n)
		if n == 5 {
			break
		}
	}

}

func gen(ctx context.Context) <-chan int {
	dst := make(chan int)
	n := 1
	go func() {
		for {
			select {
			case dst <- n:
				n++
			case <-ctx.Done():
				return // 结束这个协程
			}
		}
	}()
	return dst
}
