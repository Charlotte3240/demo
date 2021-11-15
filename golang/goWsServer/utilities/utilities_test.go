package utilities

import (
	"log"
	"reflect"
	"testing"
)

// TestBytes2str []byte 转字符串 单元测试
func TestBytes2str(t *testing.T) {
	want := "hello world"
	originBytes := []byte(want)
	got := Bytes2str(originBytes)

	if reflect.DeepEqual(want,got){
		log.Println("[]byte -> string 一致")
	}else {
		t.Error("转出来string 不一致")
	}
}

// TestStr2bytes 字符串转 []byte 单元测试
func TestStr2bytes(t *testing.T) {
	str := "hello world"
	want := []byte(str)
	got := Str2bytes(str)

	if reflect.DeepEqual(want,got){
		log.Println("str -> []byte 一致")
	}else {
		t.Error("转出来的 byte[] 不一致")
	}

}
