package main

import "fmt"

// 方法（Method）就是作用于特定类型变量的函数，这种特定类型就是 接收者。 类似于 this或者self
// 方法是属于具体类型的，其他类型不能进行调用

func main() {
	// 方法和接收者
	NewDemo("description").fool()


	// 值接收者和指针接收者
	// 值接收者,不能更改原值
	// 指针接收者,可以直接修改原值, 类似于 成员变量的存在
	d1 := NewDemo("")
	d1.fool()
	d1.SetDesc("change desc")
	d1.fool()

	d2 := NewDemo("d2 ")
	d2.fool()
}

// Demo 方法 例子
// 如果开头是大写，golang就认为是 public 对外可见的
//Demo 是一个对外可见的结构体
type Demo struct {
	desc string
}
// NewDemo 构造函数
func NewDemo(desc string) *Demo{
	return &Demo{desc}
}
// 定义方法,前面要加上类型接受者，这样子，只有这个类型才可以调用这个方法（本质是一个函数）
func (d Demo)fool(){
	fmt.Printf("类型中的变量 %s , 方法 fool\n",d.desc)
}
//SetDesc 指针接收者方法
func (d *Demo)SetDesc(desc string) {
	d.desc = desc
}
// SetDesc2 值接收者方法
func (d Demo)SetDesc2(desc string){
	d.desc = desc
}