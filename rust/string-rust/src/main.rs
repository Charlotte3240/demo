// struct Person{
//     name: String,
//     age: i32,
// }
#[derive(Debug)]
struct Person<'a>{ // 这样子标注生命周期表示 name 和 结构体的生命周期相同
    name: &'a str,
    age: i32,
}


fn main() {
    // string：字符串; &str：字面量（字符切片）
    let str = String::from("charlotte liu");

    println!("{}", str);

    // let s = "hello world".to_owned();
    let s = "hello world".to_string();
    println!("{}", s);

    let _res = str.replace("charlotte", "hc");

    println!("{_res}");


    // to_string()
    // to_owned()
    // String::from()

    // 结构体
    let name = "charlotte";
    let p = Person{
        name,
        age: 18,
    };
    println!("{:?}",p);


    // function
    print_str("hello world");
    print_str_borrow(&String::from("hello world"));

}


// 可以传递 String || &str
fn print_str(s : &str){
    println!("{}", s);
}

// 只能传递&String
fn print_str_borrow(s : &String){
    println!("{}", s);
}