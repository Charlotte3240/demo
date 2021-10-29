package main

import (
	"encoding/json"
	"encoding/xml"
	"fmt"
)

// 结构体字段可见性
// json 序列化

type Student struct {
	ID   int    `json:"id" xml:"id"`
	Name string `json:"name" xml:"name"`
}

func newStudent(id int, name string) Student {
	return Student{
		ID:   id,
		Name: name,
	}
}

type Class struct {
	Name     string    `json:"name" xml:"name"`
	Students []Student `json:"students" db:"student" xml:"students"`
}

func main() {
	c1 := Class{
		Name:     "1.1",
		Students: make([]Student, 0, 20),
	}
	fmt.Printf("%#v \n", c1)
	for i := 0; i < 10; i++ {
		tempStud := newStudent(i, fmt.Sprintf("%02d号", i))
		c1.Students = append(c1.Students, tempStud)
	}
	// 序列化json
	data, err := json.Marshal(c1)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Printf("%s\n", data)
	// 反序列化json
	jsonStr := `
{"Name":"1.1","students":[{"id":0,"name":"00号"},{"id":1,"name":"01号"},{"id":2,"name":"02号"}]}
`
	xmlStr := `
<xml version="1.0" encoding="UTF-8" >
	<Name>1.1</Name>
	<students>
		<id>0</id>
		<name>00号</name>
	</students>
	<students>
		<id>1</id>
		<name>01号</name>
	</students>
	<students>
		<id>2</id>
		<name>02号</name>
	</students>
	
</xml>
	
`
	var c2 Class
	// json 反序列化
	err = json.Unmarshal([]byte(jsonStr), &c2)
	if err != nil {
		fmt.Println("json unMarshal error:",err)
	}
	// xml 反序列化
	err = xml.Unmarshal([]byte(xmlStr),&c2)
	if err != nil {
		fmt.Println("xml unMarshal error:",err)
	}

	fmt.Println("c2:",c2)

}
