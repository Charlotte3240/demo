package main

import (
	"bufio"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
)

// 文件操作
func main() {
	// MARK: - 读取文件
	// os.open /close 打开 关闭文件
	//c, err := openFile("./reflection.go")
	//fmt.Println(string(c),err)
	//// 使用bufio
	//openFile2("./fileOp.go")
	// 使用ioutil
	//readfile3()

	//MARK:- 写入文件
	// 使用openfile写入文件
	//writeFile1()
	// 使用bufio写入文件
	//writeFile2()

	// 使用ioutil 来写入文件
	writeFile3()
}
// writeFile3 使用ioutil 写入文件
func writeFile3(){
	err := ioutil.WriteFile("./log.txt", []byte("ioutil 写入的内1容"), 0777)
	if err != nil {
		log.Println("ioutil write file err",err.Error())
		return
	}
}

//writeFile2 使用bufio 写入文件
func writeFile2(){
	fileObj,err := os.OpenFile("./log.txt",os.O_WRONLY|os.O_APPEND| os.O_CREATE,0777)
	defer fileObj.Close()
	if err != nil{
		log.Println("open file err",err.Error())
		return
	}

	w := bufio.NewWriter(fileObj)
	w.Write([]byte("write \n"))
	w.WriteString("write string \n")
	w.WriteByte('b')
	w.WriteRune(rune('😓'))
	w.Flush()
}


func writeFile1(){
	/*
	os.O_WRONLY 只写
	os.O_APPEND 追加
	os.O_TRUNC  清空
	os.O_CREATE 创建
	*/

	fileObj,err := os.OpenFile("./log.txt",os.O_WRONLY|os.O_APPEND| os.O_CREATE,0777)
	defer fileObj.Close()
	if err != nil{
		log.Println("open file err",err.Error())
		return
	}
	fileObj.Write([]byte("new line content \n"))
	fileObj.WriteString("write a string \n")
}

// readfile3 使用ioutil
func readfile3(){
	content,err := ioutil.ReadFile("./fileOp.go")
	if err != nil{
		log.Println(err)
		return
	}
	log.Println(string(content))
}


// 使用bufio来读取
func openFile2(path string) {

	// file obj
	fileObj ,err := os.Open(path)
	if err != nil{
		log.Println("open file fail ",err.Error())
		return
	}

	defer func() {
		fileObj.Close()
	}()
	reader := bufio.NewReader(fileObj)
	for {
		content, err := reader.ReadString('\n')
		if err == io.EOF{
			log.Println("read complete")
			return
		}
		if err != nil{
			log.Println("read from file fail",err.Error())
			return
		}
		fmt.Printf(content)
	}
}

// 使用os.open 来读取
func openFile(path string) ([]byte, error) {
	// 打开文件
	file, err := os.Open(path)
	if err != nil {
		fmt.Println("open file fail :", err)
	}
	fmt.Println(file)

	// 指定长度的切片
	var content = make([]byte, 1000)
	var n = -1
	for {
		var tmp = make([]byte, 1000)
		n, err = file.Read(tmp)
		// 如果中文正好卡在1000这里就会形成乱码
		content = append(content, tmp[:n]...)
		if n < 1000 || err != nil {
			break
		}
	}
	//fmt.Println(content)

	// 读取文件 到切片中
	//n,err := file.Read(tmp) // n 是读到了多少字节，0的时候就是没有内容了,这时的err为 EOF（end of file）
	//fmt.Println("本次读取了",n,"个字节",string(tmp[:n]),err)
	//if n > 0{
	//	// 转换成string 来读取，不然，中文会乱码
	//	for _, v := range string(tmp) {
	//		fmt.Printf("%c",v)
	//	}
	//}

	// 关闭文件
	defer file.Close()
	return content, err
}
