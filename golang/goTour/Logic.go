package main

import (
	"fmt"
	"strings"
)

func main() {
	str := "hello world"
	//if len(str) > 10{
	//	fmt.Println("too long ")
	//}else{
	//	fmt.Println("suit")
	//}

	str = strings.TrimSuffix(str,"world")

	switch  {
	case len(str) > 10:
		fmt.Println("too long ")
	case len(str) < 5:
		fmt.Println("too short")
	default:
		fmt.Println("suit")
	}

}