package main

import (
	"fmt"
	"strconv"
	"sync"
)

// syncMap 一种并发安全的map

var (
	wg     sync.WaitGroup
	m      = make(map[int]int) // fatal error: concurrent map writes, 如果并发的读写操作map，就需要加一个读写互斥锁
	rwlock sync.RWMutex
	m2     = sync.Map{} // 开箱即用
	/*

	 */
)

func main() {

	for i := 0; i < 30; i++ {
		wg.Add(2)
		go setMapvalue(i, i+1)
		go getMapvalue(i)
	}
	wg.Wait()
	fmt.Println(m)

	// sync.Map 使用
	syncMapUseage()

	// sync.Map 在并发读写时不需要加锁
	concurrentMap()

}

func concurrentMap() {
	m2 = sync.Map{}
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(i int) {
			m2.Store("key"+strconv.Itoa(i), "value")
			fmt.Println(m2.Load("ket" + strconv.Itoa(i)))
			wg.Done()
		}(i)
	}
	wg.Wait()
	// 遍历 sync.map
	m2.Range(func(key, value interface{}) bool {
		fmt.Println(key, value)
		return true
	})
}

func syncMapUseage() {
	// 取value
	v, ok := m2.Load("title")
	fmt.Println("load:", v, ok)

	// 取value 没有就给一个默认值 ， ok代表 有没有原值
	m2.Store("title1", "value")
	actual, ok := m2.LoadOrStore("title1", "defaultvalue")
	fmt.Println("loadOrStroe:", actual, ok)

	// 设置key value
	m2.Store("title", "value")
	fmt.Println("store:", m2)

	// 删除key value
	m2.Delete("title")
	fmt.Println("delete:", m2)

	// 如果有就加载，并且删除这个key
	v, ok = m2.LoadAndDelete("title1")
	fmt.Println("loadAndStore:", v, ok)

	for i := 5; i < 10; i++ {
		m2.Store("title"+strconv.Itoa(i), "value")
	}

	// 遍历key value
	m2.Range(func(key, value interface{}) bool {
		fmt.Println("range:", key, value)
		return true //return false 就停止遍历
	})
}

func getMapvalue(key int) int {
	rwlock.RLock()
	v := m[key]
	rwlock.RUnlock()
	wg.Done()
	return v
}

func setMapvalue(key, value int) {
	rwlock.Lock()
	m[key] = value
	rwlock.Unlock()
	defer wg.Done()
}

// enumerate 遍历sync.map
func enumerateMap() {
	m2.Range(enumerateCallback)
}

func enumerateCallback(key, value any) bool {
	// 返回false 时停止遍历
	return true
}
