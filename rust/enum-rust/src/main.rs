// 和swift 枚举类似，可以传入参数
enum Shape{
    Circle(f64),
    Rectangle(f64,f64),
    Square(f64),
    Other,
}

impl Shape {
    fn print_shape(&self){
        match self {
            Shape::Circle(r) => println!("半径是r {}", r),
            Shape::Rectangle(h, w) => println!("高是h {} 宽是w {}", h, w),
            _ => println!("impl other"),
        }
    }
}



// 常用的枚举
enum Option<T>{
    Some(T),
    None,
}

enum Result<T,E>{
    Ok(T),
    Err(E),
}



fn main() {
    println!("Hello, world!");

    // 使用match 进行模式匹配

    let enum_a = Shape::Circle(1.0);
    let enum_a = Shape::Other;
    match enum_a{
        Shape::Circle(x) => {
            println!("Circle:{}",x);
            println!("Circle banjing :{}",x);
        },
        Shape::Rectangle(x,y) => println!("Rectangle:{}",x*y),
        Shape::Square(x) => println!("Square:{}",x*x),
        _ => println!("other"), // 表示default 匹配
    }
    enum_a.print_shape();

    let num = 51;

    match num{
        1 => println!("one"),
        2 => println!("two"),
        3 => println!("three"),
        123 | 321 => println!("123 or 321"),   // | 表示或
        4..=10 => println!("1..=10"), // 包括10
        11..=15 => println!("11..15"),
        n if n%2 == 0 => println!("%2 ==0 "),
        _ => println!("other num"),
    }


}
