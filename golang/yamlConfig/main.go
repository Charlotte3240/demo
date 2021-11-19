package main

import (
	"io/ioutil"
	"log"

	"gopkg.in/yaml.v2"
)

type Config struct {
	PypinyinAddr string `yaml:"pypinyinAddr"`
	TfsAddr      string `yaml:"tfsAddr"`
}

var TTSConfig = &Config{}

func LoadConifg() {
	// 读文件，拿到[]byte
	data, err := ioutil.ReadFile("./config.yml")
	if err != nil {
		log.Fatalln("读取配置文件失败")
	}
	err = yaml.Unmarshal(data, TTSConfig)
	if err != nil {
		log.Fatalln("unmarshal config.yaml error: ", err.Error())
	}
	log.Println("读取配置文件成功")
}

func main() {
	LoadConifg()
	log.Println(TTSConfig.PypinyinAddr)
	log.Println(TTSConfig.TfsAddr)
}
