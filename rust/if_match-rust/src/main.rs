use rand::Rng;

fn main() {
    let app_code = "webchat_dd";
    
    if app_code.starts_with("webchat_") {
        println!("start with webchat");
    }else{
        println!("not start with webchat");
    }


    let mut rng = rand::thread_rng();
    let num:i32 = rng.gen_range(0..100);
    // let num:i32 = 16; // 只会在match 里面匹配一次， 从上到下的顺序
    match num {
        10..=20 => println!("10..20"),
        33|44|55 => println!("33|44|55"),
        x if x %2 == 0 => println!("even"),
        _ => println!("other"),
    }
    println!("{num}");

    let is_oushu = match num % 2 {
        0 => true,
        _ => false
    };
    println!("是否为偶数{}",is_oushu);
}
