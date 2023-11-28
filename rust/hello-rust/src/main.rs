use ferris_says::say;
use std::io::{stdout, BufWriter};
fn main() {
    let stdout = stdout();
    let message = String::from("hello fellow Rustaceans!");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    say(&message, width, &mut  writer).unwrap();

    println!("hello world");

    let name = "charlotte";
    println!("name is {}", name);

    types()
}


fn types(){
    let num1 : i32 = 1;
    let num2 : u32 = 2;
    let num3 : isize = 3; // arch 长度 根据cpu架构决定，32位就是32位， 64位是64位
    let num4 : usize = 4;

    println!("{} {} {} {}", num1, num2, num3, num4);

    // let num5:i8 = 188;
    // println!("{}", num5);

    let f1: f32 = 3.14; // 单精度
    let f2: f64 = 3.1415926; // 双精度

    println!("{} {}",f1,f2);
}