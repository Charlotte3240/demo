package main

import "fmt"

func main()  {
	// for 循环

	// 基本格式
	for i:=0; i<10; i++{
		fmt.Println(i)
	}
	// 变种1
	i:= 0
	for; i< 10;i++ {
		fmt.Println(i)
	}

	//变种2
	i = 0
	for i <10 {
		i++
		fmt.Printf("变种2:%d\n",i+2)
	}

	// 死循环
	//for {
	//	fmt.Println("死循环")
	//}

	// for range
	str := "hello world"
	for index , value := range str{
		fmt.Println(index,string(value))
	}

	// 9*9 乘法表
	for i:= 1 ; i<= 9; i++ {
		for j := 1; j<= i; j++ {
			fmt.Printf("%d x %d = %d ",i,j,i*j)
		}
		fmt.Println("")
	}

	// 循环打断
	for i := 0; i < 10; i++ {
		if i == 5{
			continue
		}
		fmt.Println(i)
	}
}