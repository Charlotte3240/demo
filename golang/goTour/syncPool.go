package main

import (
	"log"
	"sync"
	"time"
)

// Obj 初始化比较耗时的结构体
// 或者开辟内存空间较大的结构体
type Obj struct {
	Name string
}

func (o *Obj) doSth() {
	log.Println("obj is going to do something")
}

var ObjPool = sync.Pool{New: func() interface{} {
	return &Obj{Name: "init"}
}}

func main() {
	// 使用时get取出
	obj := ObjPool.Get().(*Obj)
	obj.doSth()
	// 用完后put放回
	ObjPool.Put(obj)

	time.Sleep(10 * time.Second)
}
