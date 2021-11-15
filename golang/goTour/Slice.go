package main

import "fmt"

func main() {
	// ‼️ 切片是一个引用类型
	// 声明一个empty 切片 此时，切片不是nil
	intSlice := []int{}
	//var intSlice []int
	// ‼️ 这种声明形式，使用之前一定要初始化，不然可能会造成越界
	// 声明一个nil 的切片
	var stringSlice []string

	fmt.Println("empty是否等于nil", intSlice == nil)
	fmt.Println(intSlice, stringSlice)

	s1 := []string{"1", "2", "1", "2", "1", "2", "1", "2", "1", "2", "1", "2"}
	s2 := s1
	// 由于切片是引用类型，所以这里更改了s2之后，s1也会进行更改
	s2[0] = "-1"
	fmt.Println(s1, s2)

	fmt.Println(intSlice == nil, len(intSlice) == 0)

	//fmt.Println(stringSlice[0])

	// 切片的长度和容量
	fmt.Println(len(s1), cap(s1))

	// 由数组构造切片
	var array = [...]int{1, 2, 4, 6}

	var arrSlice = array[0:len(array)]
	// 从0位开始切割 到最后
	arrSlice = array[:len(array)]

	// 全部数据转化切片
	arrSlice = array[:]

	// 从2位开始切割 到最后
	arrSlice = array[2:]

	arrSlice = array[1:3]

	fmt.Println(arrSlice)
	// 切片容量，是指底层数组的容量（会从切片的开始位 开始计算容量）
	// 所以从0位开始转化的切片，容量不变， 从不是0位开始转化的切片，容量会变小
	fmt.Printf("%T len:%d cap:%d \n", arrSlice, len(arrSlice), cap(arrSlice))

	var temp = arrSlice[1:2]

	fmt.Printf("%v %d %d \n", temp, len(temp), cap(temp))

	// 切片不能直接进行比较,slice can only be compared to nil
	// 只能比较里面的值
	s3 := []int{}
	fmt.Printf("%v len:%d cap:%d \n", s3, len(s3), cap(s3))
	//s3 = append(s3, 3)
	// 判断一个切片是否为空，或者 是否可用，使用len 进行判断
	if len(s3) > 0 {
		fmt.Println("可以使用")
	} else {
		fmt.Println("空的切片")
	}

	// 切片的遍历
	s4 := []int{1, 2, 3, 4}
	for i, v := range s4[:3] {
		fmt.Println(i, v)
	}

	// 追加 append, 如果超出了cap值，cap小于1024时 2倍扩容， 大于1024时 1.25倍扩容，如果加到内存不够1.25倍，就扩容剩余内存的容量
	// string 和 int 类型会有一些不同
	s4 = append(s4, 3)
	fmt.Println(s4, len(s4), cap(s4))
	s4 = append(s4, 3, 4, 5, 9)

	s5 := []int{17, 18, 19}
	// ... 代表 unpack slice（打开切片）
	s4 = append(s4, s5...)

	fmt.Println(s4, len(s4), cap(s4))

	s6 := []int{}
	for i := 0; i < 1024; i++ {
		s6 = append(s6, i)
	}
	s4 = append(s4, s6...)

	fmt.Println(s4, len(s4), cap(s4))

	s7 := []int{}
	for i := 0; i < 148; i++ {
		s7 = append(s7, i)
	}
	s4 = append(s4, s7...)
	fmt.Println(s4, len(s4), cap(s4))

	s4 = append(s4, 1)
	fmt.Println(s4, len(s4), cap(s4))

	// 切片的清空
	fmt.Println("准备开始演示 clear slice ")
	fmt.Println(s4)
	s4 = s4[:0]
	fmt.Println("cleared", s4, "len:", len(s4), cap(s4))

	s4 = append(s4, s7...)
	fmt.Println(s4, len(s4), cap(s4))

	s4 = nil
	fmt.Println(s4, len(s4), cap(s4))
	s4 = append(s4, s7...)
	fmt.Println(s4, len(s4), cap(s4))

	a := []string{"A", "B", "C", "D", "E"}
	a = a[:0]
	fmt.Println(a, len(a), cap(a)) // [] 0 5
	a = append(a, "gg")
	a = append(a, "")
	fmt.Println(a[1])
}
