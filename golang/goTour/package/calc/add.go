package calc

import "fmt"
import _ "nsqk.com/packageDemo/hcDismiss"
import _ "nsqk.com/packageDemo/hcSort"

// 默认包名是文件夹的名字

var Name = "charlotte"

// Add 首字母大写对外开放时，要写上注释
func Add(x, y int) int {
	// 同一个包中的所有文件，不需要引入，可以直接调用
	//return Sub(x,y)
	//fmt.Println(SubString)
	return x + y
}


// init 函数没有参数，也没有返回值，导入会自动执行
// init 会在全局声明后再执行
// 一个包里面只能有一个init 函数
// 同一个文件下 导入多个包里面都有init,从上到下执行
// a包里面有init，b中也有， main引入a，a中引入b，执行顺序为 b.init -> a.init -> main()
func init() {
	fmt.Println("calc init ")
}

// 执行顺序
// 1. 全局声明
// 2. init()
// 3. main()

func deinit() {
	fmt.Println("deinit call")
}
