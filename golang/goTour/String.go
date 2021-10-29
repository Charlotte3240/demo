package main

import (
	"bytes"
	"fmt"
	"strings"
)



func main() {
	var str = "this is string value"
	/*原始字符串*/
	var originStr = `ddsadsa#%""`
	fmt.Println(len(originStr))

	// 字符串拼接
	//var sumStr = str + " " +  originStr
	// 格式化字符串后并返回
	var sumStr = fmt.Sprintf("%s%s",str,originStr)
	fmt.Println(sumStr)

	/*
		字符串切割
		使用strings 中的Split 方法
	*/
	var items = strings.Split(sumStr," ")
	fmt.Printf("split %v",items)
	/*join */
	fmt.Println(strings.Join(items,"-"))

	/*
		判断是否包含 字串
	*/
	if strings.ContainsAny(sumStr,"dd"){
		fmt.Println("yse , find it ")
	}else {
		fmt.Println("not found")
	}

	/*
		prefix suffix
		TrimPrefix  TrimSuffix
	*/
	fmt.Printf("has suffix %t\n",strings.HasSuffix(sumStr,`"`))
	fmt.Printf("has prefix %t\n",strings.HasPrefix(sumStr,"thi"))
	/*Trim 没有对旧值进行修改，而是生成了一个新的，这和swift 值类型很相似*/
	fmt.Printf("trim prefix %s\n",strings.TrimPrefix(sumStr,`this`))
	fmt.Printf("trim suffix %s\n",strings.TrimSuffix(sumStr,`""`))
	fmt.Println(sumStr)

	/*
		子串的位置
		index
	*/
	// 初始位置
	index := strings.Index(sumStr,"is")
	// 最后位置
	lastIndex := strings.LastIndex(sumStr,"is")
	// 字串
	counts := strings.IndexFunc(sumStr, func(c rune) bool {
		fmt.Println(c)
		if c == 'i' {
			return  true
		}
		return false
	})


	fmt.Println(index,lastIndex)
	fmt.Println(counts)
	// 声明一个type 来 创造方法 进行操作
	fmt.Println(String.ReverseString("test"))


	path := "D://ddd/ddd/ddd"
	fmt.Printf("%#v",path)

	// 多行字符串
	mutibleLineString := `a
b
	c
	`
	fmt.Println(mutibleLineString)

	// 字符串格式化并且拼接
	formatterString := fmt.Sprintf("a:%s b:%s",path,mutibleLineString)
	fmt.Println(formatterString)
	fmt.Println(strings.Contains(mutibleLineString,"c"))

	// rune 或者 utf-8 是 int32
	for _ , c := range path{
		fmt.Printf("%T ",c)
	}
	// byte 或者ascii 是 uint8
	for i:= 0; i<len(path); i++{
		fmt.Printf("%T ",path[i])
	}

	// 字符串是不能修改的，只能转成切片来进行修改
	var stringVar = "hello"
	var runeVar = []rune(stringVar)
	runeVar[0] = 'd'
	fmt.Println(string(runeVar))


	var value  = "hello中文字符"

	var count  = 0

	for _ ,c  := range value{
		if c > 126 || c < 32{
			count+=1
		}
	}
	fmt.Println(count)



}

// 声明一个类型
type String string
// 给这个类型的接受者 增加一个方法
func (i String) ReverseString() string {
	return "test extension"
}


// 拼接字符串，大量超过1w条使用 buffer
func largeStringSplice(){
	var buffer bytes.Buffer

	var string = "string "

	for  {
		buffer.WriteString(string)
	}
	fmt.Println(buffer.String())
}