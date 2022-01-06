package main

import (
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strings"
	"time"
)

func main() {

	// url parameters
	urlStr := "http://localhost:50000/doc"

	param := url.Values{}
	param.Set("name", "刘春奇")
	param.Set("age", "ageValue")
	param.Set("sex", "male")
	url, err := url.ParseRequestURI(urlStr)
	if err != nil {
		log.Println("url parse request url failed", err)
	}
	url.RawQuery = param.Encode() // url encode
	log.Println(url.String())     // 2021/11/23 14:02:23 http://localhost:50000/doc?age=ageValue&name=%E5%88%98%E6%98%A5%E5%A5%87&sex=male
	time.Sleep(time.Second * 2)
	// go http https client
	resp, err := http.Get(url.String())
	if err != nil {
		log.Println("get http client error", err)
	}
	value, err := ioutil.ReadAll(resp.Body)
	log.Println(resp.StatusCode, string(value))

	resp, err = http.Post("http://www.baidu.com", "application/json", strings.NewReader("hello world"))
	if err != nil {
		log.Println("post http client error", err)
	}
	defer resp.Body.Close()
	value, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Println("post http resp body read fail", err)
	}

	log.Println(resp.StatusCode, string(value))

}
