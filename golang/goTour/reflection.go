package main

import (
	"fmt"
	"reflect"
	"time"
)

type Cat struct {
}

type Dog struct {
}

// 反射
func main1() {
	// reflection 包
	a := 1.2323
	b := 2333
	c := []int{}
	d := []string{}
	e := Cat{}
	f := Dog{}
	g := &a

	reflectType(a) // name: float64 , kind: slice
	reflectType(b) // name: int , kind: slice
	// go 语言中 array slice map ptr Reflect.typeOf().Name()都是空的
	reflectType(c) // name:  , kind: slice
	reflectType(d) // name:  , kind: slice
	reflectType(e) // name: Cat , kind: struct
	reflectType(f) // name: Dog , kind: struct
	reflectType(g) // name:  , kind: ptr

	if reflect.TypeOf(f).Name() == "Dog" {
		fmt.Println("一致")
	}
	if reflect.TypeOf(g).Name() == "*float64" {
		// name 获取不到
		fmt.Println("一致 根据Name()")
	} else if reflect.TypeOf(g).String() == "*float64" {
		fmt.Println("一致 根据String()")
	}
	v := reflect.Zero(reflect.TypeOf(a))
	fmt.Printf("%T %#v\n", v, v)

	//reflect.ArrayOf(10,reflect.TypeOf(a))
	// 可以通过反射包中的 reflect.ValueOf().Interface() 转成 interface 类型
	// 再通过类型断言转成可以使用的类型
	fmt.Println(reflect.ValueOf(a).Interface())
	aa := reflect.ValueOf(a).Interface()

	// 除了转成interface类型之外，可以直接转换成原始类型（可以直接使用的类型）
	// ⚠️：如果转换不成功，就panic了
	aa = reflect.ValueOf(a).Int()

	typea, ok := aa.(float64)
	if !ok {
		fmt.Println("不能转成float64", typea)
	} else {
		fmt.Printf("%T %#v\n", typea, typea)
	}

	fmt.Printf("%T %#v", aa, aa)

	// 总结
	// reflect.TypeOf() 查看类型
	//	 .Name() : array slice map ptr 获取的是空值
	//	 .Kind() : 原始种类，type a struct ，获取的是 struct
	//	 .String(): 弥补了Name 获取不到的缺点，

}

func reflectType(i interface{}) {
	v := reflect.TypeOf(i)
	//fmt.Printf("%T\n",v) // *reflect.rtype
	fmt.Println(v, v.Name(), v.Kind(), v.String())
}

func reflectValue(i interface{}) {
	v := reflect.ValueOf(i)
	fmt.Printf("%T %v\n", v, v) // reflect.Value 100
	switch v.Kind() {
	case reflect.Float64:
		// 把reflect.Array 转成Array
		f := v.Float()
		fmt.Println(f, "float64")
	case reflect.Int:
		f := v.Int()
		fmt.Println(f, "int")
	default:
		fmt.Println("default:", v.Kind(), v)
	}
}

func reflectSetValue(i interface{}) {
	// Elem 在反射中根据指针取值
	v := reflect.ValueOf(i).Elem() // 如果传进来的是指针，v就是一个地址
	k := v.Kind()
	fmt.Println(v, k, v.String())
	switch k {
	case reflect.Int:
		//int
		v.SetInt(2333)
	case reflect.Float64:
		//float 64
		v.SetFloat(3.1415926)
	default:
		fmt.Println("没有找到相应的类型", k)
	}
}

func main2() {
	var x float64
	x = 100

	//reflectValue(x)
	//reflectValue(32)

	// reflect set value
	// panic: reflect: reflect.Value.SetFloat using unaddressable value
	// golang中传参数默认是值拷贝，修改函数中的副本，没有办法寻址，所以这里需要传递指针
	//reflectSetValue(x)
	reflectSetValue(&x)
	fmt.Println(x)

	// isNil() 参数必须是通道、函数、接口、映射、指针、切片中的一种，否则会Panic
	var m map[string]string

	fmt.Println(reflect.ValueOf(m).IsNil())

	// isValid() 判断value 是否持有一个值
	// 如果是零值 返回 false，此时除了IsValid String Kind 之外的方法都会Panic
	var i2 interface{}
	fmt.Println(reflect.ValueOf(i2).IsValid())

	// IsNil   通常用来判断指针是否为空
	// IsValid 判断返回值是否有效

	var a *int
	fmt.Println("a is nil?", reflect.ValueOf(a).IsNil())
	fmt.Println("a is valid?", reflect.ValueOf(a).IsValid())

	b := struct {
	}{}
	//fmt.Println("b is nil?", reflect.ValueOf(b).IsNil())// panic ， 只能用于特殊类型
	fmt.Println("b is valid?", reflect.ValueOf(b).IsValid()) // IsValid = true

	//查找结构体字段
	//fmt.Println(reflect.ValueOf(b).FieldByName("name"))// <invalid reflect.Value>
	fmt.Println(reflect.ValueOf(b).FieldByName("name").IsValid())        // true
	fmt.Println(reflect.ValueOf(b).MethodByName("methodName").IsValid()) //true

	// 尝试从map中查找一个不存在的key
	var c = map[string]string{}
	fmt.Println(reflect.ValueOf(c).MapIndex(reflect.ValueOf("title")).IsValid())

	// 使用反射获取 结构体的字段
	stu := ReflectDemo{
		Name: "charlotte",
		Time: time.Now(),
	}

	t := reflect.TypeOf(stu)
	// 获取结构体的字段个数后，根据索引获取结构体字段
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		fmt.Printf("name:%v  path:%v type:%v tag:%v index:%v \n", field.Name, field.PkgPath, field.Type, field.Tag, field.Index)
		// 获取tag的值
		fmt.Println(field.Tag.Get("json"), field.Tag.Get("ini"))
	}
	// 根据名字获取结构体中的字段
	fields, ok := t.FieldByName("Names")
	if ok {
		fmt.Printf("%#v\n", fields)
	} else {
		fmt.Println("没有找到")
	}

	// 获取结构体中的方法
	r := ReflectDemo{
		Name: "dsadsadas",
		Time: time.Now(),
	}
	// 只拿来看的时候可以通过TypeOf ， 如果要对拿来的值做操作，就需要通过ValueOf拿到
	fmt.Println(reflect.TypeOf(r).NumMethod(), reflect.ValueOf(r).NumMethod())
	t = reflect.TypeOf(r)
	v := reflect.ValueOf(r)
	for i := 0; i < v.NumMethod(); i++ {
		method := reflect.ValueOf(r).Method(i)
		// 打印每个方法,从Type.Method()获取name
		fmt.Printf("%#v %#v\n", method, t.Method(i).Name)
		// 获取入参和出参个数,
		m2 := reflect.TypeOf(r).Method(i)
		//fmt.Println(m2.Type.NumIn(),m2.Type.NumOut())

		//// 循环打印入参
		//fmt.Println("入参")
		//for i := 0; i < m2.Type.NumIn(); i++ {
		//	fmt.Println(i,":",m2.Type.In(i))
		//}
		//// 循环打印出参
		//fmt.Println("出参")
		//for i := 0; i < m2.Type.NumOut(); i++ {
		//	fmt.Println(i,":",method.Type().Out(i))
		//}

		// 调用方法, 需要传递参数
		// 需要需要传递参数，类型一定是reflect.Value 类型
		args := make([]reflect.Value, 0)

		if m2.Type.NumIn() > 1 {
			args = append(args, reflect.ValueOf("callArgs"))
		}
		method.Call(args)
	}

}

func main() {
	//fn()
	getNameOfMethod()
}

func getNameOfMethod() {
	d := ReflectDemo{
		Name: "reflect demo name",
		Time: time.Now(),
	}
	t := reflect.TypeOf(d)
	v := reflect.ValueOf(d)

	// 根据方法名获取结构体的方法
	tm , ok := t.MethodByName("Fn1") // 根据typeOf获取 返回的是 method，bool 类型
	vm := v.MethodByName("Fn1") // 根据valueOf 返回的是Value 类型

	fmt.Println(tm,"-",tm.Type,"-",ok)
	fmt.Println(vm,vm.Type())
}

func fn() {
	r := ReflectDemo{
		Name: "reflect struct",
		Time: time.Now(),
	}
	// struct 方法第一个参数一定是接收者，所以NumIn 一定 >=1
	// 普通函数 没有接收者，NumIn就有可能是0
	fmt.Println(reflect.TypeOf(fn).NumIn())                // 普通函数 入参为0
	fmt.Println(reflect.TypeOf(r).Method(0).Type.NumIn())  // 结构体方法，肯定大于一个入参，第一个为接收者 ，这里是2
	fmt.Println(reflect.ValueOf(r).Method(0).Type().In(0)) // 结构体方法，获取第0个入参，从接收者后面开始算，如果这里填In(1)就越界了
	return
	args := make([]reflect.Value, 0)
	args = append(args, reflect.ValueOf(r))
	args = append(args, reflect.ValueOf("callParam"))
	reflect.ValueOf(r).Method(0).Call(args)
}

type ReflectDemo struct {
	Name string    `json:"name" ini:"r_name"`
	Time time.Time `json:"time" ini:"r_time"`
}

func (r ReflectDemo) Fn1(args string) string {
	fmt.Println("call fn1")
	return "11" + args
}
func (r ReflectDemo) Fn2() int {
	fmt.Println("call fn2")
	return 22
}
