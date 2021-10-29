package main

import (
	"fmt"
	"strings"
)

func main() {
	fmt.Println(sumInt3(111, 22, 2))
	fmt.Println(sumAndSub(111, 222))
	tempGlobalVariable()

	// go语言中，函数也是一等公民
	fn := tempGlobalVariable
	fn()
	fmt.Printf("%T\n", fn)                   // func() 类型
	fmt.Printf("%T %T\n", fn, sumInts(1, 2)) // 如果函数有返回值，那函数的类型就是这个返回值的类型

	result := calc(1, 2, func(x int, y int) int {
		return x + y
	})
	fmt.Println(result)
	fmt.Println(calc(1, 3, add))

	// 匿名函数
	anonymousFunc := func() {
		fmt.Println("匿名函数")
	}
	anonymousFunc()
	// 立即执行函数
	func() {
		fmt.Println("直接执行这个匿名函数")
	}()
	// 自定义 传入的参数（匿名函数的 函数体）
	res := func(x, y int) int {
		return x + y
	}(1, 2)
	fmt.Println(res)

	// 闭包 = （函数+引用环境）
	r := fn2("一个name") // r就是一个闭包
	r()

	r2 := addSuffixString("\n转载请表明出处！\npowered by www.hc-nsqk.com")("这是随便写的东西")
	fmt.Println(r2)

	sum, sub := calc2(100)
	fmt.Println(sum(200))
	fmt.Println(sub(200))
}

func calc2(baseValue int) (func(int) int, func(int) int) {
	add := func(num int) int {
		return baseValue + num
	}
	sub := func(num int) int {
		return baseValue - num
	}
	return add, sub
}

func addSuffixString(suffix string) func(string) string {
	return func(name string) string {
		if strings.HasSuffix(name, suffix) {
			return name
		} else {
			return name + suffix
		}
	}
}

// 定义一个函数， 并且返回一个匿名函数,把函数作为一个返回值
func fn2(name string) func() {
	return func() {
		fmt.Println(name)
	}
}

// 匿名函数当作参数时，就差不多变成了闭包
func calc(x, y int, option func(int, int) int) int {
	return option(x, y)
}
func add(x, y int) int {
	return x + y
}

func sumInts(a, b int) int {
	return a + b
}

func sumInt(a, b int) (res int) {
	// 返回的结果可以声明成一个变量，在函数体中，就不需要来声明
	// 可以直接拿来使用
	res = a + b
	// return 的时候也可以不写这个变量，毕竟声明函数的时候已经说了要返回这个变量了
	return
}

// 函数接收一个可变参数,一个函数只能接收一个可变参数
// 这里表示，可以接收多个int参数,这里的a就变成了切片
// go语言中没有默认参数，但是可以通过传入多个函数，在函数中返回一个默认值，来实现默认参数
func sumInt3(a int, b ...int) int {
	res := 0
	for _, value := range b {
		res += value
	}
	res += a
	return res
}

// go 语言函数支持多个返回值
// 多个返回值，用()包括起来
func sumAndSub(a, b int) (sum, sub int) {
	sum = a + b
	sub = a - b
	defer fmt.Println("ddd") // 只能在return 前面
	return
	//return a+b,a-b
}

// go语言中 局部变量可以和全局变量重复命名，在函数中局部变量的优先级会更高
var sum = 1

func tempGlobalVariable() {
	var sum = 2
	fmt.Println(sum)
}
