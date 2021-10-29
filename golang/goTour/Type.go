package main

import (
	"fmt"
	"reflect"
)

// 基于int 类型自定义了一个类型
type MyInt int

// 类型别名
type OtherInt = MyInt



func main() {
	// 自定义类型
	a := MyInt(3)
	fmt.Println(reflect.TypeOf(a)) // 类型是 main.MyInt
	fmt.Println(OtherInt(222))     // 类型是int

	tempInterface(123)
	tempInterface(new(Dog))
}
func tempInterface(i interface{}) {
	//fmt.Printf("%T %#v\n", i, i)
	assert(i)
}

type Animal interface {
	run()
}

type Dog struct {
	legs int
	mouth int
}

func (d Dog)run (){
	fmt.Println("dog 实现run 接口")
}

// 类型断言
func assert(i interface{}) {

	defer func() {
		err := recover()
		if err != nil {
			fmt.Println(i,"类型断言:", err)
		}
	}()
	s := i.(Animal)
	//s := i.(int) // 这里只能接收int类型，如果不是，就会Panic
	fmt.Println(s)
}
