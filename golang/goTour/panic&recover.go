package main

import "fmt"

func main() {
	// panic 和 recover
	a()
	b()
	c()

	// 复习了一下指针内容
	a := 10
	b := &a
	c := &b
	fmt.Printf("%v %p\n", a, &a)
	fmt.Printf("%v %p\n", b, &b)
	fmt.Printf("%v %p\n", c, &b)
	fmt.Println(**c)

}

func a() {
	fmt.Println("func a")
}

func b() {
	// 在可能出现Panic的代码之前，写defer recover来进行恢复
	defer func() {
		err := recover()
		if err != nil {
			fmt.Println("func b error ", "错误信息:", err)
		}
	}()
	// panic 类似于 swift中的 assert
	panic("执行了b函数中的panic 代码")
}

func c() {
	fmt.Println("func c")
}
