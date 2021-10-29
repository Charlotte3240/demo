package main

import "fmt"

type Animal struct {
	Name string
}
func (a *Animal) move(){
	fmt.Println(a.Name,"在移动")
}

type Cat struct {
	Tail int // 尾巴数量
	*Animal // 结构体，不单单可以嵌套结构体，还可以嵌套结构体的指针
}

func (c *Cat)eat(){
	fmt.Println(c.Name,"有",c.Tail,"条尾巴")
}


func main() {
	c1 := Cat{1,&Animal{
		Name: "猫",
	}}
	c1.eat()
	c1.move()
}