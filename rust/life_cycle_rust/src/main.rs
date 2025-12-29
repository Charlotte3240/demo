

fn main() {
    // borrow checker 
    /*
        1. 可以存在多个不可变引用
        2. 不能同时存在可变引用和不可变引用
        3. 不能同时存在多个可变引用
        4. 不能在可变引用被创建后，对不可变引用进行修改
     */

     let mut s = String::from("hello");
     let r1 = &s;
     let r2  = &s;
     println!("{} {}", r1, r2);

    let r3 = &mut s;
    println!("{}", r3);
    // println!("{} {}", r1, r2);

    let mut r4 : &str = "hello";
    println!("{}", r4);
    {
        let res = "hello world2";
        r4 = test_life_cycle(res, &false);
    }
    println!("{}", r4);
    println!("{}", test1("dd", "aaa"));
    println!("{}", test2("dd", "aaa"));
    println!("{}", test3("dd", "aaa"));

}

fn test_life_cycle<'a>(res: &'a str, ok: &bool) -> &'a str {
    if *ok {
        return "ok";
    }
    res
}

fn test1(s1: &'static str, s2: &str) -> &'static str{
    let len = s1.len() + s2.len();
    let res = format!("拼接后长度为{}", len);
    Box::leak(Box::new(res))
}


fn test2<'a>(s1:&'a str, s2:&'a str) -> &'a str{
    if s1.len() > s2.len(){
        s1
    }else{
        s2
    }
}

fn test3<'a, 'b, 'out>(s1:&'a str, s2:&'b str) -> &'out str where 'a: 'out, 'b: 'out,{
    if s1.len() > s2.len(){
        s1
    }else{
        s2
    }
}