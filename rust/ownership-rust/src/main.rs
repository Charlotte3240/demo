struct Counter{
    num : i32
}

impl Counter {
    fn new (num: i32) -> Self{
        Self{num}
    }
    // 不可变借用 borrow
    fn get_number(&self) -> i32{
        self.num
    }
    // 可变借用
    fn increase_number(&mut self, increase : i32) {
        self.num += increase
    }
    // 移动 move
    fn give_up(self){
        // println!("{}", self.num)
    }

    fn combine(c1:Self, c2:Self) ->Self{
        return Self{num: c1.num + c2.num}
    }
}

fn main() {
    let mut c = Counter::new(100);
    println!("{}",c.get_number());
    c.increase_number(1);
    println!("{}",c.get_number());

    // c.give_up();
    // Error: value borrowed here after move
    // println!("{}",c.get_number());
    let c1 = c;
    let c2 = Counter::new(200);
    let c3 = Counter::combine(c1,c2);
    println!("{}",c3.get_number());
}
