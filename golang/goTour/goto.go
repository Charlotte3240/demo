package main

import "fmt"

func main(){
	gotoTag:
		fmt.Println("goto标签")

	for i := 0; i < 100; i++ {
		if i == 50{
			goto gotoTag
		}
		fmt.Println(i)
	}
}