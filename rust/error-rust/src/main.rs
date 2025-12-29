use std::num::ParseIntError;


fn chufa(a:f64, b:f64) -> Result<f64, String>{
    if b == 0.0{
        return Err(String::from("chushu shi 0"));
    }else{
        return Ok(a / b);
    }
}


fn find_item(data: &Vec<i32>, value : i32) -> Option<i32>{
    for ele in data {
        if *ele == value{
            return Some(*ele);
        }
    }
    return None;
}

fn find_item_index<T:PartialEq>(data: Vec<T>, value : T) -> Option<usize>{
    for (index, ele) in data.iter().enumerate(){
        if *ele == value{
            return Some(index);
        }
    }
    return None;
}


fn find_even_value(data:Vec<i32>) -> Option<i32>{
    let value = data.iter().find(|&x| x % 2 ==0)?;
    // 结果为None 的时候 提前返回了 ,因为上面有？解包
    println!("value is not none");
    return Some(*value)
}

fn parse_int(data: &str) -> Result<i32, ParseIntError>{
    let value = data.parse::<i32>()?;
    Ok(value)
}

fn main() -> Result<(), Box<dyn std::error::Error>>{
    // result
    let res = chufa(1.0, 3.0);
    match res{
        Ok(v) => println!("{}", v),
        Err(e) => println!("{}", e)
    }
    println!("{:?}", chufa(1.0, 3.0));
    println!("{:?}", chufa(1.00, 0.0));
    // optional
    let arr = vec![1,2,3,4,5];
    match find_item(&arr, 3) {
        None => println!("not found"),
        Some(v) => println!("found {}", v)
    }
    println!("{:?}", arr);
    match find_item_index(vec![1,2,3,4,5], 3) {
        None => println!("not found"),
        Some(v) => println!("found index is {}", v)
    }

    // panic
    // let vec = vec![1,2,3,4,6];
    // println!("{}",vec[441]);


    // 解包
    // unwrap 可以用于 Option 和 Result，相当于直接取ok 和 some 里面的值，如果是 err 或者 none 会直接panic
    // ? 通常用于提前返回函数，如果拿到值继续执行函数代码，拿到 err 或者 none 会结束函数运行直接返回


    println!("{}", chufa(1.1, 3.3).unwrap());
    // println!("{}", chufa(10.0, 0.0).unwrap()); // panic

    let res: Result<bool, String> = Ok(true);
    // let res: Result<bool, String> = Err(String::from("dsadasd")); // panic
    println!("{}", res.clone().unwrap());
    let _res: Result<bool, String> = Err(String::from("dsadasd"));
    let res: Result<bool, String> = Ok(false);
    // 使用? 进行解包时 函数必须要有Result包装类型的返回值
    // 在输出 Error 的时候会让函数提前退出, 返回 Err(e)
    println!("{}", res?); 


    let v = vec![1,2,3,4,5];
    println!("{}",find_item(&v, 3).unwrap());


    let even_value = find_even_value(vec![1,3,4,5]);
    match even_value {
        Some(e) => {
            println!("find value is {e}");
        },
        None => {
            println!("not find value");
        },
    }

    // println!("find even value {}",find_even_value(vec![1,3,5]).ok_or("not found value").unwrap());


    // println!("{}", parse_int("dsadsadsa")?);

    test_my_error()?;
    println!("上面 test_my_error 让函数提前结束了，这行不会打印");

    return Ok(());

}



fn test_my_error() -> Result<(), HCError>{
    Err(HCError{
        message: String::from("hello world"),
    })
}


#[derive(Debug)]
struct HCError {
    message: String,
}

impl std::error::Error for HCError {
    fn description(&self) -> &str {
        &self.message
    }
}

impl std::fmt::Display for HCError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.message)
    }
}
