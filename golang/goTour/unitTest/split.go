package unitTest

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"io"
	"strings"
)

// Split 切割字符串 , (charlotte ,l) -> {char,otte}
func Split(s, sep string) (result []string) {
	index := strings.Index(s, sep)
	// 返回值提前申请内存，避免重复malloc
	result = make([]string, 0, strings.Count(s, sep)+1)
	for index > -1 {
		result = append(result, s[:index])
		s = s[index+len(sep):]
		index = strings.Index(s, sep)
	}
	result = append(result, s[:])
	return
}

func Md51() string {
	str := "123456"
	// md5 []byte 14.291µs
	has := md5.Sum([]byte(str))
	md5Str := fmt.Sprintf("%x", has)
	return md5Str

}

func Md52() string {
	str := "123456"
	//md5 string  1.667µs
	h := md5.New()
	io.WriteString(h, str)
	md5Str := fmt.Sprintf("%x", h.Sum(nil))
	return md5Str
}
func Md53() string {
	str := "123456"
	//md5 string 917ns 最快
	h2 := md5.New()
	h2.Write([]byte(str))
	md5Str := hex.EncodeToString(h2.Sum(nil))
	return md5Str
}
