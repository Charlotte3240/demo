package main

import (
	"github.com/mozillazg/go-pinyin"
	"log"
	"regexp"
	s "sensitiveWords/sensitive_match"
)

func main() {
	sensitiveWords := []string{
		"傻逼",
		"傻叉",
		"垃圾",
		"妈的",
		"sb",
		"傻b",
		"臭",
		"逼",
	}
	m := s.NewSensitiveTrie()
	m.AddWords(sensitiveWords)
	matchContents := []string{
		"你是一个大傻&逼，大傻 叉",
		"你是傻☺叉",
		"shabi东西",
		"他made东西",
		"傻逼逼逼逼逼",
		"什么垃圾打野，傻逼一样，叫你来开龙不来，SB",
		"正常的内容☺",
	}
	for _, content := range matchContents {
		words, changed := m.Match(content)
		log.Println(words)
		log.Println(changed)
	}

}

func pinyinTest(words []string) {
	pinyinContents := make([]string, 0)
	for _, content := range words {
		//判断是否包含中文
		reg := regexp.MustCompile("[\u4e00-\u9fa5]")
		if !reg.Match([]byte(content)) {
			// 不包含中文
			continue
		}
		pinpins := pinyin.Pinyin(content, pinyin.NewArgs())
		for _, pinpin := range pinpins {
			pinyinContents = append(pinyinContents, pinpin...)
			log.Println(pinpin)
		}

	}
}
