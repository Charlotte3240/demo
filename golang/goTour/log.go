package main

import (
	"log"
	"os"
)

// log 包使用
func main() {
	log.Println("普通的日志") // 2021/11/23 10:25:39.642248 /Users/jr/Documents/demo/golang/goTour/log.go:10: 普通的日志

	// 创建logger
	logger := log.New(os.Stdout, "[new logger]", log.Lshortfile|log.Ldate|log.Lmicroseconds)
	logger.Println("logger print message") // [new logger]2021/11/23 10:28:17.003957 log.go:14: logger print message
}

func init() {
	logFile, err := os.OpenFile("./log.log", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatalln("open file fail", err)
	}
	log.SetOutput(logFile)
	log.SetFlags(log.Llongfile | log.Lmicroseconds | log.Ldate)
}

func example() {
	log.Println("普通的一条日志") // 2021/11/23 10:21:09 普通的一条日志

	// set prefix
	log.SetPrefix("log prefix ")
	log.Println("普通的一条日志") // log prefix 2021/11/23 10:21:27 普通的一条日志

	// set output
	logFile, err := os.OpenFile("./log.log", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatalln("open file fail", err)
	}
	log.SetOutput(logFile)
	log.Println("普通的一条日志") // in file log.log : log prefix 2021/11/23 10:23:10 普通的一条日志
}
