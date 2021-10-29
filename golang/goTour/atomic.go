package main

import (
	"fmt"
	"sync/atomic"
)

// 原子操作，因为上下文切换比较耗时，锁的底层实现也时原子操作，直接使用cpu的指令
func main() {
	var a int64
	a = atomic.AddInt64(&a,64)
	fmt.Println(a)

	// 读取
	//atomic.LoadInt64(&a)
	fmt.Println(atomic.LoadInt64(&a))

	// 写入
	atomic.StoreInt64(&a,2333)
	fmt.Println(a)

	// 修改 生成的是一个新的地址的值,这里是做了一个加法
	newa := atomic.AddInt64(&a,64)
	fmt.Println(newa,a)

	// 交换值，把新值换到地址上，返回旧值
	var b int64 = 34
	old := atomic.SwapInt64(&a,b)
	fmt.Println(a,b,old)
}
