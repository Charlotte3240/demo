package main

import (
	"fmt"
	"strconv"
	"strings"
)

// map 和 slice 组合
func main() {
	// 元素类型是map的 slice

	s1 := make([]map[string]string,0,10)// 尽量预估一下容量，len 设置为0，不然会有零值填充

	s1 = append(append(s1, map[string]string{
		"key": "value",
	}), map[string]string{
		"name":"charlotte",
	})
	// 设置value的时候，要保证里面的map 不是nil
	s1 = append(s1, make(map[string]string ,1))
	s1[2]["ley"] = "value"

	fmt.Println(s1)

	// 值为切片的map
	var m1 = make(map[string][]string,1)
	m1["key"] = []string{"shanghai"}
	fmt.Println(m1)

	fmt.Println("练习题")
	str := "how do you do"
	slice := strings.Split(str," ")
	// 创建一个map 来存储key是短语 value是出现次数
	var valueMap = make(map[string]int,10)
	for _, value := range slice {
		// 先查找有没有这个key，如果有这个key，value就加一
		if _ ,ok := valueMap[value]; ok{
			valueMap[value] = valueMap[value]+1
		}else {
			// 没有这个key，value就等于1
			valueMap[value] = 1
		}
	}
	fmt.Println(valueMap)
	// 找出value最大的键值队
	var maxMap = map[string]string{
		"maxCount":"",
		"maxKey":"",
	}
	for key, value := range valueMap {
		maxCount ,_ := strconv.Atoi(maxMap["maxCount"])
		if value > maxCount{
			maxMap["maxKey"] = key
			maxMap["maxCount"] = fmt.Sprintf("%d",value)
		}
	}
	fmt.Println(maxMap)


	type Map map[string][]int
	m := make(Map)
	s := []int{1, 2}
	s = append(s, 3)
	fmt.Printf("%+v\n", s)
	m["q1mi"] = s
	s = append(s[:1], s[2:]...)
	fmt.Printf("%+v\n", s)
	fmt.Printf("%+v\n", m["q1mi"])// map中的value引用的还是原来的切片
	m["q1mi"] = s
	fmt.Println(m)
}