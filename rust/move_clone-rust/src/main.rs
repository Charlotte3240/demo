
#[derive(Debug, Clone, Copy)]
struct Message {
    id :i32,
    time: i64
}

#[derive(Debug, Clone, Copy)]
struct Signal<'a> {
    from: &'a str,
    to: &'a str
}


fn main() {
    // 基础类型，存放在栈上，遮蔽 操作形式为 clone
    // vec 存放在堆上， 遮蔽 操作形式为 move 
    let x = 1;
    let y = 1;
    println!("{:?}",x);
    println!("{:?}",y);

    let x = "hello world".to_string();
    let y = x.clone();
    println!("{:?}",x);
    println!("{:?}",y);

    let x = vec![1,2,3,4];
    // let y = x; borrowed after move
    let y = x.clone();
    println!("{:?}",x);
    println!("{:?}",y);

    // 虽然结构体上的类型存放在栈上，但这里还是 move
    let x = Message {
        id: 1,
        time: 2
    };
    // let y = x; // borrowed after move
    let y = x.clone(); // 这里的 struct 没有clone 方法，会报错， 需要在derive 上标明 Clone, Copy
    println!("{:?}",x);
    println!("{:?}",y);    
    println!("{:}, {:}",x.id, x.time);    


    let x = Signal {
        from: "hello",
        to: "world"
    };
    let y = x.clone();
    println!("{:?}",x);
    println!("{:?}",y);
    println!("{:}, {:}",x.from, x.to);
}
