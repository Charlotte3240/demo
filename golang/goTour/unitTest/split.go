package unitTest

import (
	"strings"
)

// Split 切割字符串 , (charlotte ,l) -> {char,otte}
func Split(s, sep string)(result []string){
	index := strings.Index(s, sep)
	// 返回值提前申请内存，避免重复malloc
	result = make([]string,0,strings.Count(s,sep)+1)
	for index > -1 {
		result = append(result,s[:index])
		s = s[index+len(sep):]
		index = strings.Index(s,sep)
	}
	result = append(result,s[:])
	return
}


