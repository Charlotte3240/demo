package main

import (
	"fmt"
	"nsqk.com/packageDemo/calc"
)

// 倒入包的双引号前面可以起别名，来区分相同的包的名字
// 匿名倒入包, 只倒入，不在这个文件中使用，但是可以通过钩子函数来运行一些代码
//import _ "fmt"
// main 包，程序入口
func main() {
	fmt.Println(calc.Add(1,2))
}
