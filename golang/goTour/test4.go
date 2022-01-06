package main

import (
	"log"
	"strings"
)

func main() {
	str := "t0"
	if strings.Contains(str, ":") {
		arr := strings.Split(str, ":")
		str = arr[len(arr)-1]
	} else {
		str = "0"
	}
	log.Println(str)
}
