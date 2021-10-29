package main

import "fmt"

func main()  {

	var code = 200
	fmt.Println("input code !")
	fmt.Scanln(&code)
	switch  {
	case code == 200:
		fmt.Println("正常返回")
	case code > 500:
		fmt.Println("server error")
	case code == 401, code > 400 :
		fmt.Println("token 过期 或 参数错误")
	default:
		fmt.Println("unknown code")
	}

	//switch fmt.Scanf(&code) , code{
	//case 1:
	//	fmt.Println("1")
	//default:
	//	fmt.Println("default")
	//}
}