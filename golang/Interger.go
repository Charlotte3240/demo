package main

import "fmt"

func main(){
	test()
}

type VCError struct {
	code string
	msg string
	data string
}
func test(){
	error := VCError{code: "200",msg: "success"}
	fmt.Print(error.code)
	//fmt.Printf("%+v",error)
}
