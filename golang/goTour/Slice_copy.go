package main

import "fmt"

func main() {
	// 切片的copy
	s1 := []int{1,2,3}
	s2 := s1

	//var s3 []int // 这里的切片是nil 所以什么都没有拷贝到，拷贝的时候空间一定要足够
	s3 := make([]int,3) // 这里就会把s1的所有值都拷贝过来
	copy(s3, s1) // 这里指的是深拷贝
	fmt.Println(s1,s2,s3) // [1 2 3] [1 2 3] [1 2 3]
	s1[0] = 0
	fmt.Println(s1,s2,s3) // [0 2 3] [0 2 3] [1 2 3]
	fmt.Printf("%p %p %p \n",s1,s2,s3)

	// append, 使用append 删除中间的元素
	// go中没有remove这个方法
	s1 = append(s1[:1], s1[2:]...)
	fmt.Println(s1)

	// dropFirst
	fmt.Println(s1[1:])
	// dropLast
	fmt.Println(s1[:len(s1)-1])

	//a1 := []int{1,2,3}
	array := [...]int{1,2,3,4,5,6}
	a1 := array[:]
	a1 = append(a1[:1],a1[2:]...) // ⚠️ append 不开辟新的内存空间，所以一定要有变量来接收
	a1[0] = 0
	fmt.Println(array)



}