fn main() {
    println!("{} , {}",i8::MAX, i8::MIN);
    println!("{}",i16::MAX);
    println!("{}",i32::MAX);
    println!("{}",i64::MAX);
    println!("{}",u32::MAX);
    println!("{}",usize::MAX);
    println!("{}",isize::MAX);


    println!("{}", std::mem::size_of::<i32>());
    println!("{}", std::mem::size_of::<u32>());

    println!("{}", std::mem::size_of::<i64>());
    println!("{}", std::mem::size_of::<u64>());


    println!("{}", std::mem::size_of::<isize>());
    println!("{}", std::mem::size_of::<usize>());


    let mut f1: f32 = 3.1415926;
    let f2: f64 = 3.88255611;

    println!("{:.2}",f1);
    println!("{:.3}",f2);
    f1 = 77.1;

    let mut f3: f32 = f1;
    f3 = 77.3;
    println!("change : {f3}, {f1}");

    let arr = ["hello","world"];
    for ele in arr {
        println!("{}",ele);
    }
    println!("{:?}",arr.last());

    println!("{}",some_func());

    let arr = [1;3];
    for item in arr{
        println!("iter: {item}");
    }

}

fn some_func () -> i32 {
    return 1;
}
