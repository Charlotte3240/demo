package main

import (
	"fmt"
	"sort"
)

func main() {
	//var a = make([]int,5,10)
	//fmt.Println(a)
	//for i := 0; i < 10; i++ {
	//	a = append(a, i)
	//}
	//fmt.Println(a)

	//var b = []int{2,3,4}
	//fmt.Printf("%p\n",b)
	//// 第一个append 相当于copy了一份
	//b = append(append(b[:0:0], 1), b...)
	//fmt.Printf("%p\n",b)
	//fmt.Println(b)
	//
	//var c []int // 这里的c没有初始化，所以没有空间容量，下面的拷贝不会成功
	//copy(c,b)
	//fmt.Println(c) // []
	//c = make([]int,len(b)) // 初始化b的长度
	//fmt.Printf("%p\n",c)
	////copy(c,b)
	//c = append([]int(nil), 1)
	//fmt.Printf("%p\n",c)
	//fmt.Println(c,len(c), cap(c)) //[1,2,3,4]

	//var b = []int{2,3,4}
	//var t1 = reflect.TypeOf(b)
	//fmt.Printf("%v",t1) // []int%
	//
	//var s = make(reflect.Type(b), 5)
	////var s = make(t1,5)
	//fmt.Printf(s)

	a := []int{1,2,3,4}
	//fmt.Println(insert(s1,2333,22))
	//
	//fmt.Println(insert2(s1,[]int{24444,1223},2))
	//
	//fmt.Println(insert3(s1,456,2))

	a= append(a[:2],a[2+1:]...)
	fmt.Println(a)

	var sortArray = [...]int{3,7,8,9,1}
	// 数组不能排序，切片可以
	sort.Slice(sortArray[:],func(i int,j int)bool{
		return sortArray[i] > sortArray[j]
	})
	//sort.Ints(sortArray[:])
	fmt.Println(sortArray)
}

//MARK: -中间插入

// 把前半部分，后半部分生成新的切片，最后再组合到一起
func insert(origin []int, args int, index int) []int{
	if index > len(origin){
		return  nil
	}
	prefix := make([]int,index)
	suffix := make([]int,len(origin)-index)

	copy(prefix, origin[:index])
	copy(suffix,origin[index:])
	fmt.Println(prefix,suffix)
	return append(append(prefix, args), suffix...)
}
// 创建了一个新的切片
func insert2(origin []int,args []int ,index int) []int{
	return append(origin[:index],append(args,origin[index:]...)...)
}
// 避免创建新的切片
func insert3(origin []int,args int ,index int) []int{
	// 先向后增加一位，然后再往后移一位，再把中间的值改掉
	origin = append(origin, 0)
	// 在这块内存的内部，copy内容，相当于后移一位
	copy(origin[index+1:],origin[index:])
	// 更改下标的值
	origin[index] = args
	return origin
}