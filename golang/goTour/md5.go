package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"time"
)

func main() {
	for i := 0; i < 100; i++ {
		test()
	}
}

/*
BenchmarkMd51-8          3847366               311.5 ns/op            64 B/op          3 allocs/op
BenchmarkMd52-8          4186201               286.4 ns/op           176 B/op          5 allocs/op
BenchmarkMd53-8          6357022               187.6 ns/op            80 B/op          3 allocs/op

*/

func testSpeed(){
	str := "123456"
	// md5 []byte 14.291µs
	startTime := time.Now()
	has := md5.Sum([]byte(str))
	md5Str := fmt.Sprintf("%x",has)
	log.Println("1: ",md5Str,time.Now().Sub(startTime))

	//md5 string  1.667µs
	startTime = time.Now()
	h := md5.New()
	io.WriteString(h,str)
	md5Str2 := fmt.Sprintf("%x",h.Sum(nil))
	log.Println("2: ",md5Str2,time.Now().Sub(startTime))

	//md5 string 917ns 最快
	startTime = time.Now()
	h2 := md5.New()
	h2.Write([]byte(str))
	md5Str3 := hex.EncodeToString(h2.Sum(nil))
	log.Println("3: ",md5Str3,time.Now().Sub(startTime))
}