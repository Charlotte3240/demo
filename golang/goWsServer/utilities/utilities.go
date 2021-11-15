package utilities

import (
	"log"
	"unsafe"
)

// Str2bytes 字符串转[]byte 指针转换
func Str2bytes(s string) []byte {
	x := (*[2]uintptr)(unsafe.Pointer(&s))
	h := [3]uintptr{x[0], x[1], x[1]}
	return *(*[]byte)(unsafe.Pointer(&h))
}

// Bytes2str []byte 转string 指针转换
func Bytes2str(b []byte) string {
	return *(*string)(unsafe.Pointer(&b))
}
// example 示例
func example(){
	str := "hello world"
	bytes := []byte(str)

	// []byte 转 string
	log.Println(Bytes2str(bytes))
	// string 转 []byte
	log.Println(Str2bytes(str))

}