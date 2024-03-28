// 生成项目文档 cargo doc --open
use std::{io, cmp::Ordering};

use rand::Rng;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    let secret_num = rand::thread_rng().gen_range(1..=100);

    loop { // 创建循环，和golang for{} 类似
        let mut guess = String::new();

        io::stdin().read_line(&mut guess).expect("failed read input line");

        let guess:u32 = match guess.trim().parse() {
            Ok(e) => e,
            Err(err) => {
                println!("please type integer, {err}");
                continue;
            }
        };

        match guess.cmp(&secret_num) {
            Ordering::Less => println!("less"),
            Ordering::Greater => println!("greater"),
            Ordering::Equal => {
                println!("equal");
                break;
            }
        };
    }
}
