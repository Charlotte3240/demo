package main

import "fmt"

	// 声明全局变量
	var (
		a int = 456
		b string = "jr"
	)

	// 全局变量才可以 声明了而不使用
	var  c int

	

func main()  {

	// 声明局部变量
	// 声明了局部变量之后，一定要使用，不然会编译报错
	// var value1,value2,value3 int
	// value1,value2,value3 = 1,2,3

	// value1,value2,value3,value4 := 3,2,1,0
	

	// 值类型 进行赋值时进行拷贝操作（和swift 类似，copy on write）
	var ca = a
	var cb = b

	fmt.Println(&a,&ca,&b,&cb)


	// 忽略变量 同swift中的效果
	_ , charlotte := "balabala" , "user name"
	fmt.Println(charlotte)


	// 用于抛弃函数返回的某些 返回值
	_ , returnStr := testReturnValues()

	fmt.Println(returnStr)

	const letValue string = "string const value"

	fmt.Println(letValue)

	// 常量可以声明后 不使用 和 全局变量相同
	const letValue2 = "another const value"
	fmt.Println(letValue2)

	const width = 23
	const height = 12

	fmt.Println(getAreaFromWidthAndHeight(width,height))

}

// 求面积
func getAreaFromWidthAndHeight(width int , height int)(int){
	return  width * height
}


func testReturnValues() (int , string) {
	return 1222,"string value"
}
