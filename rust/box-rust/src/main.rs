#[derive(Debug)]
struct Point{
    x : i32,
    y : i32
}

fn main() {
    // Box::new 包一层 放在了堆上
    let p = Box::new(Point{x:1,y:2});
    println!("{:?}", p);

    // 把基础数据类型放在堆上
    let mut num = Box::new(100);
    println!("num: {}",num);
    println!("num: {}",*num);

    // Box 是一个智能指针，rust 中没有指针偏移的运算
    // num = num + 1;

    // 解引用之后就是 i32 数据类型，就可以进行运算了
    *num = *num + 1;
    println!("num: {}",num);
}
