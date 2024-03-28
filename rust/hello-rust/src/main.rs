use ferris_says::say;
use core::f32;
use std::{io::{stdout, BufWriter}};
// use std::io::;

fn main() {
    let stdout = stdout();
    let message = String::from("hello fellow Rustaceans!");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    say(&message, width, &mut  writer).unwrap();

    println!("hello world");

    let name = "charlotte";
    println!("name is {}", name);

    types();

    variable();
}


fn variable(){
    let const_v = 1;
    let mut var_v = 2333;
    println!("{const_v}, {var_v}");

    var_v = 1111;
    println!("{const_v}, {var_v}");


    const C: &str = "const value";
    println!("{C}");

    // 隐藏变量
    let name = "charlotte";
    let name = "chunqi.liu";
    println!("{name}");

    // 甚至更改变量类型
    let price = 9.9;
    let price = "9.9";
    println!("{price}")

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

    // let f3: i8 = 1100 as i8; // 直接报错，溢出
    // println!("{}",f3);

    let f4 = 1_000_000_000.123;
    println!("{}",f4);

    let b:bool = false;
    println!("bool type is {b}");

    let c: char = 'c';
    println!("char type is {c}");

}