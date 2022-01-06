package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	ErrorFCode()

	/*
		%v => 值的默认展示方式
		%+v => 对比上面，加上了键值
		%#v => 值的go语言形式
		%T => 类型
		%c => unioncode
		%b => 二进制
		%q => 带双引号的形式
	*/
	m := map[string]string{
		"title": "value",
	}
	log.Printf("%v", m)                     // map[title:value]
	log.Printf("%+v", m)                    // map[title:value]
	log.Printf("%#v", m)                    // map[string]string{"title":"value"}
	log.Printf("%T", m)                     // map[string]string
	log.Printf("%b", []byte("hello world")) // [1101000 1100101 1101100 1101100 1101111 100000 1110111 1101111 1110010 1101100 1100100]
	log.Printf("%q", m)                     // map["title":"value"]

	// 宽度占位符
	n := 3.14
	log.Printf("%9.2f", n) // 9是宽度，2是保留小数位，     3.14
}

func ErrorFCode() {
	err := fmt.Errorf("this is an error description")
	log.Println(err)

	w := errors.New("an new error description")
	// 可以用%w, 来占位一个error 类型
	err = fmt.Errorf("this is an error description ,new: %w", w)
	log.Println(err)

}

func SprintCode() {
	// 格式化输出，并且返回一个字符串类型
	h := "hello world"
	str := fmt.Sprintf("this is a string %s", h)
	log.Println(str)
}

func FprintCode() {
	// Fprint 标准输出
	fmt.Fprintln(os.Stdout, "hello world")

	fileObj, err := os.OpenFile("./log.txt", os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
	if err != nil {
		log.Fatalln("open file err", err)
		return
	}
	// 写入文件
	fmt.Fprintf(fileObj, "Fprintf append content")

	fileData, err := ioutil.ReadFile("./log.txt")
	if err != nil {
		log.Fatalln("read file err", err)
	}
	log.Println(string(fileData))
}
