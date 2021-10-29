package main

import (
	"fmt"
	"os"
)

// 文件操作
func main() {
	// os.open /close 打开 关闭文件
	c, err := openFile("./reflection.go")
	fmt.Println(string(c),err)

}


// 使用bufio来读取
func openFile2(path string) {

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
