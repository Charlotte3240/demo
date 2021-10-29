package main

import (
	"fmt"
	"math/rand"
	"sort"
	"time"
)

func main() {
	// map 和 切片一样都是引用类型
	// 基于散列表

	// map[key的类型]value类型
	m1 := map[string]string{
		"title":"标题",
		"nav":"导航",
	}
	fmt.Println(m1)

	// 和切片一样， 必须要初始化才能使用
	var map1 map[string]string
	//map1["title"] = "标题" //panic: assignment to entry in nil map
	// 这里初始化，和切片类似，（类型,容量）
	map1 = make(map[string]string,1) // 尽量一次给足容量，避免在运行时进行扩容
	map1["title"] = "标题"
	map1["sex"] = "male"
	map1["key"] = "value"
	fmt.Println(map1)


	v,ok := map1["title"]
	// 习俗用ok来接收一个bool值
	if ok {
		fmt.Println(v)
	}else {
		fmt.Println("not found key")
	}

	// 如果非要取一个不存在的key，会返回该类型的一个零值
	fmt.Println(map1["key"])

	// map 的遍历
	for key, value := range map1 {
		fmt.Println(key,value)
	}
	// 只遍历key
	for key := range map1{
		fmt.Println(key)
	}
	// 只遍历value
	for _ ,value := range map1{
		fmt.Println(value)
	}

	// 删除键值对
	fmt.Println(map1)
	delete(map1,"key")
	delete(map1,"key1")// 删除一个不存在的key，没有任何作用，也不会产生崩溃
	fmt.Println(map1)

	// map 排序，map本身是无序的，只能把key全部取出来进行排序
	m2 := make(map[string]string,110)
	// 初始化随机种子
	rand.Seed(time.Now().UnixMicro())

	for i := 0; i < 100; i++ {
		key := fmt.Sprintf("nsqk-%02d",i) // 如果有后面数字位数不一致，排序会有问题 比如 89 9 90
		value := fmt.Sprintf("value-%d",rand.Intn(100)) // 生成0～99的随机数
		//m2[i] = "asb"
		m2[key] = value
	}
	var keys = []string{}
	for key := range m2{
		keys = append(keys, key)
	}
	sort.Strings(keys)
	for _, key := range keys {
		fmt.Println(key,m2[key])
	}

}
