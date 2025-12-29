// 重载操作符， 和 swift 类型 只要实现了必要的特质（protocol）就可以重载操作符
use std::ops::Add;

#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Add for Point<T> where T:Add<Output = T> {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Point{
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}


fn main() {
    let p1 = Point{x: 1, y: 2};
    let p2 = Point{x: 3, y: 4};
    let p3 = p1 + p2;
    println!("p3: {:?}", p3);
}
