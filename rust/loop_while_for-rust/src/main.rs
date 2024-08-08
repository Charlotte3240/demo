use std::{thread::sleep, time::Duration};

fn main() {
    
    // loop {  // 占用一个 cpu 核心
    //     println!("Hello, world!");
    //     sleep(Duration::from_secs(1));
    // }

    let ids = [1,2,3,4,45];
    for ele in ids {
        println!("{ele}");
    }

    for i in 0..10{
        println!("{i}")
    }

    // 跳出外部循环
    'outside : loop {
        println!("out side");
        loop {
            println!("in side");
            break 'outside;
        }
    }
    
    let ids_square: Vec<_> = ids.iter().map(|&x| x*x).collect();
    println!("{:?}",ids_square);
}
