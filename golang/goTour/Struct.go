package main

import "fmt"

type Person struct {
	Name     string `json:"name"`
	Sex, Age int    `json:"sex" json:"age"`
}

func main() {
	//结构体的构造函数
	d1 := newDagongren("12345679","golang")
	fmt.Printf("%#v\n", d1)
}

type Dagongren struct {
	jNumber string // 工号
	jType   string // 工种
}

func newDagongren(jNum, jType string) *Dagongren {
	return &Dagongren{jNum, jType}
}

func main1() {
	p1 := Person{
		Age:  18,
		Name: "charlotte",
		Sex:  2,
	}
	v := p1.Name
	p2 := p1
	p1.Name = "nsqk"
	p2 = p1
	fmt.Printf("%#v\n", p1)
	fmt.Println(v)
	fmt.Println(p2)

	// 匿名结构体
	var user struct {
		name string
		age  int
	}
	user.name = "charlotte"
	user.age = 50
	fmt.Println(user)

	// 通过new 创建一个结构体指针
	var p3 = new(Person)
	(*p3).Name = "new name"
	// 对指针进行操作的时候，go语言会自动转成*p 去操作
	p3.Name = "没有括号 和 * 取值符号也可以进行赋值"
	fmt.Printf("%T\n", p3)
	fmt.Printf("%v\n", p3)

	// 取结构体的指针进行实例化
	var p4 = &Person{}
	fmt.Printf("%T %#v\n", p4, p4)

	p4.Name = "charlotte"
	fmt.Printf("%T %#v\n", p4, p4)

	//使用值的列表进行初始化
	p5 := Person{"Charlotte", 3, 35}
	fmt.Println(p5)
}
