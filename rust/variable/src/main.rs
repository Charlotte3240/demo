const PI_HC: f64 = 3.1415926;

fn main() {
    let mut x = 5;
    println!("variabel is {}", x);

    x = 6;
    println!("variabel is {}", x);

    println!("{}", PI_HC);

    // array
    let arr: [i32; 5] = [3; 5];
    for ele in arr {
        println!("{}", ele);
    }

    let arr = [1,2,3,4,5];
    for ele in arr {
        println!("{}", ele);
    }
}
