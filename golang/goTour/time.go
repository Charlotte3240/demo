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
	timeFormatter()

}

// formatter 时间格式化
func timeFormatter() {
	n := time.Now()
	// 2021-11-22T17:43:57.797 Mon Nov 24小时
	log.Println(n.Format("2006-01-02T15:04:05.000 Mon Jan"))
	// 2021/11/22 17:44:37 2021-11-22T05:44.026  12小时
	log.Println(n.Format("2006-01-02T03:04.000"))

	// location
	timeZone, err := time.LoadLocation("Asia/Shanghai")
	if err != nil {
		log.Println("load location error:", err)
	}
	log.Println(time.Now().In(timeZone).Format("2006-01-02T15:04:05.000"))
	cstZone := time.FixedZone("CST", 0*3600) // 0时区
	log.Println(time.Now().In(cstZone).Format("2006-01-02T15:04:05.000"))

	// layout : formatter string
	parseTime, err := time.ParseInLocation("2006-01-02T15:04:05.000", "2008-01-18T00:00:00.000", timeZone)
	if err != nil {
		log.Println("parse time formatter error:", err)
	}
	log.Println("parsed time:", parseTime)

}

// timer 定时器
func timer() {
	t := time.Tick(time.Second * 1)
	ticker := time.NewTicker(time.Second * 1)
	go func() {
		for {
			select {
			case <-t:
				log.Println("timer channel read data")
			}
		}

	}()
	go func() {
		for {
			select {
			case <-ticker.C:
				log.Println("ticker.C channel read data")
			}
		}
	}()

	// 两个的区别，就是tick 不需要从.C 拿到channel，本身就是个channel
	// tick 不能被关闭
	time.Sleep(time.Second * 5)
	ticker.Stop()

	time.Sleep(time.Second * 5)
}

// timeAdd 时间计算
func timeOp() {
	// 增加 输入 time.duration
	n := time.Now()
	log.Println(n.Add(1 * time.Second)) // time.time
	// 减少 输入time.time
	log.Println(time.Now().Sub(n)) // time.duration

	// equal time
	log.Println("equal", time.Now().Equal(n)) // false

	// before
	log.Println("before", time.Now().Before(n)) // false

	// after
	log.Println("after", time.Now().After(n)) // true

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
