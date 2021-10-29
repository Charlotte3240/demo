package main

import "fmt"

func main() {
	// 必须制定存放元素的 容量（长度）和类型
	// 数组的长度是数组类型的一部分
	/*	    -长度
		数组 -类型
			-元素
	*/
	var array = [3]bool{false,true,false}

	for index , value := range array{
		fmt.Printf("%d: %v \n",index,value)
	}

	//var arr1 = [4]bool{true , false, false,true}
	//
	//var arr2 = [4]bool{false,false,false,false}
	//
	//var arr3 = [3]bool{false,false,false}
	// arr2 和 arr3 的类型不同，不能进行比较
	//fmt.Println(arr1 == arr2, arr2 == arr3)

	// 默认不初始化，是有一个默认的空值
	var arr [3]bool
	fmt.Println(arr)

	// 初始化方式1
	a1 := [2]bool{true,true}
	fmt.Println(a1)
	// 初始化方式2 使用...占位（长度） ,根据值来推断长度
	an := [...]int{1,2,3,4,5,6,7,8,9}
	fmt.Println(an)
	// 初始化方式3 不给出全部的值，根据索引给定部分值
	a3 := [5]int{3:1,1:2}
	fmt.Println(a3)


	// 数组遍历
	for i := 0; i < len(a3); i++ {
		fmt.Println(a3[i])
	}

	for index, value := range a3 {
		fmt.Printf("index:%d - %d\n",index,value)
	}

	// 多维数组
	var multiArrays = [2][3]string{{"a","v","d"},{"s","q","w"}}

	fmt.Println(multiArrays)
	for _, value := range multiArrays {
		for _, neicengValue := range value {
			fmt.Println(neicengValue)
		}
	}

	//‼️ 数组是一个值类型，不能被更改, 所谓的更改是重新生成了一个数组再赋值上来的

	b1 := [3]int{1,2,3}
	// 这里只是把b1的值，拷贝给了b2
	b2 := b1
	// 所以这里修改b2的值，不会影响b1
	b2[0] = 123
	fmt.Println(b1,b2)
	var sum = 0
	for _, value := range b2 {
		sum+=value
	}
	fmt.Println(sum)

	// 两数之和 , 找出两个相加等于8的元素的索引
	var array2 = [...]int{1,3,5,7,8}
	var result [][]int
	for i, v := range array2 {
		for j := i+1; j < len(array2); j++ {
			if v + array2[j] == 8{
				result=append(result, []int{i,j})
			}
		}
	}

	fmt.Println(result)
}