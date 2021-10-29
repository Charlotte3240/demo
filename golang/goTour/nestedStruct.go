package main

import "fmt"

type Student struct {
	// 字段首字母大写，对外暴露这个字段，不然其他的包找不到这个字段
	// 而且在序列化的过程中，同样会找不到这个字段
	Age          int
	Name, Gender string
	Address      Address // 嵌套另外一个结构体
}

type Student2 struct {
	Age          int
	Name, Gender string
	Address      // 嵌套另外一个匿名结构体，这里的地址 没有写字段名称

}
type Student3 struct {
	Age            int
	Name, Gender   string
	HomeAddress    Address
	CompanyAddress Address
}

type Student4 struct {
	Age          int
	Name, Gender string
	// 结构体字段冲突，Address、Email 中都含有UpdateTime
	Address
	Email
}

type Address struct {
	Province, City, Street string
	UpdateTime             string
}
type Email struct {
	Addr       string
	UpdateTime string
}

func main() {
	var s1 = Student{
		Age:    18,
		Name:   "charlotte",
		Gender: "male",
		Address: Address{
			Province: "shanghai",
			City:     "shanghai",
			Street:   "pudong",
		},
	}
	fmt.Println(s1)

	s2 := Student2{18, "nsqk.com", "male", Address{"shanghai", "pudong", "zhangjiang","2021-10-18"}}
	s3 := Student2{
		Age:    17,
		Name:   "ivy4ever.com",
		Gender: "male",
		Address: Address{
			Province: "上海",
			City:     "浦东",
			Street:   "唐镇",
		},
	}
	fmt.Println(s2, s3)
	// 嵌套结构体，如果类型只出现一次，可以跨层级访问
	fmt.Println(s3.Address.Street, s3.Street)

	// 多个相同类型嵌套，就不能跨层级访问了
	s4 := Student3{19, "name", "gender",
		Address{"上海", "浦东", "机场","2021-10-18"},
		Address{"上海", "浦东", "张江","2021-10-18"}}
	fmt.Println(s4.HomeAddress.Street, s4.CompanyAddress.Street)

	// 结构体中第三层有相同的字段，也不能跨层进行访问
	s5 := Student4{
		Age:11,
		Name: "name",
		Gender: "female",
		Address: Address{
			Province: "上海",
			City: "shanghai",
			Street: "zhangjiang",
			UpdateTime: "2021-10-17",
		},
		Email:Email{
			Addr: "momo_sad@163.com",
			UpdateTime: "2021-10-18",
		},
	}
	//fmt.Println(s5.UpdateTime) //Ambiguous reference 'UpdateTime' 模凌两可的指向 Updatetime
	fmt.Println(s5.Address.UpdateTime,s5.Email.UpdateTime) //一定要一层一层访问，不然有多个UpdateTime，编译会失败

}
