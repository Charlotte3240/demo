package main

import (
	"fmt"
	"os"
)

// 新增
// 编辑
// 删除
// 查询

var stuM StuManager

func main() {
	stuM = *NewStuManager()

	for {
		fmt.Println("Hello！Manage System！")
		fmt.Println("1. add")
		fmt.Println("2. del")
		fmt.Println("3. alert")
		fmt.Println("4. select")
		fmt.Println("5. exit")
		var commond int
		fmt.Scanf("%d", &commond)
		fmt.Println("select commond:", commond)
		switch commond {
		case 1:
			addStudent()
		case 2:
			delStudent()
		case 3:
			alertStudent()
		case 4:
			selectStudent()
		case 5:
			os.Exit(0)
		}

	}

}
// 添加一个新的
func addStudent() {
	stu := inputStudent()
	stuM.addStudent(stu)
}

// 根据id 删除
func delStudent() {
	stuM.delStudent(inputStudent())
}

// 根据id修改
func alertStudent() {
	stuM.alertStudent(inputStudent())
}
// 打印所有
func selectStudent() {
	for index, stu := range stuM.AllStus {
		fmt.Println("index:",index,"stu:",stu)
	}
}

// 从输入转struct
func inputStudent()Student{
	fmt.Println("input id、name、class")
	var id int
	var name, class string
	fmt.Scanf("%v", &id)
	fmt.Scanf("%v", &name)
	fmt.Scanf("%v", &class)
	return Student{id,name,class}
}