package main

import (
	"log"
	"time"
)

// time 包的一些用法
func main() {
	// ticker := time.NewTicker(time.Millisecond * 500)
	// log.Println(time.Now())
	// time.Tick(time.Millisecond * 500)
	// log.Println(time.Now())

	// for t, i2 := range ticker.C {

	// }

	timeOp()
}

// timeAdd 时间计算
func timeOp() {
	// 增加 输入 time.duration
	n := time.Now()
	log.Println(n.Add(1 * time.Second)) // time.time
	// 减少 输入time.time
	log.Println(time.Now().Sub(n)) // time.duration
}

// duration 时间间隔
func duration() {
	start := time.Now()
	dur := time.Now().Sub(start) //dur : time.duration
	log.Println(dur)             // 250ns 最长可表达290年
}

// timestamp
func timestamp() {
	now := time.Now()
	timeStamp1 := now.Unix()      // 秒 1637048824
	timeStamp2 := now.UnixMilli() // 毫秒 1637048879287
	timeStamp3 := now.UnixMicro() // 微秒 1637048879287143
	timeStamp4 := now.UnixNano()  // 时间戳 纳秒 1637048824489914000
	log.Println(timeStamp1)
	log.Println(timeStamp2)
	log.Println(timeStamp3)
	log.Println(timeStamp4)

}

// currentTime  当前时间
func currentTime() {
	now := time.Now()
	log.Println(now.Year())
	log.Println(now.Month())
	log.Println(now.Day())
	log.Println(now.Hour())
	log.Println(now.Minute())
	log.Println(now.Second())
	log.Println(now.UnixMilli())
	log.Println(now.Nanosecond())
	// 格式化
	log.Printf("%d年 %02d月 %02d日 \n", now.Year(), now.Month(), now.Day())
	log.Printf("%02d时 %02d分 %2d秒 %d毫秒  %d纳秒 \n", now.Hour(), now.Minute(), now.Second(), now.UnixMilli(), now.Nanosecond())
}
