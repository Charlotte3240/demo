enum Gender{
    Male,
    Female,
}


struct Person {
    name: String,
    age: i32,
    height: f64,
    weight: f64,
    gender: Gender,
    smoker: bool
}

impl Person{
    const SAVING_MONEY: f64 = 1000.0;
    // 静态变量 声明周期是整个应用程序
    // static count: i32 = 0;

    // 方法
    fn has_somoker(&self)->bool{
        self.smoker
    }

    fn bmi(h: f64, w: f64)->f64{
        w/ (h * h)
    }
    // 关联函数
    fn new(name : String) -> Person{
        Person{
            name,
            age: 0,
            height: 0.0,
            weight: 0.0,
            gender: Gender::Male,
            smoker: false
        }
    }
}

fn print_person(p: Person){
    println!("{}", p.name);
    println!("{}", p.age);
    match p.gender {
        Gender::Male => println!("Male"),
        Gender::Female => println!("Female")
    };
    println!("存款是：{}",Person::SAVING_MONEY);
}


fn main() {
    let p = Person{
        name: "John".to_string(),
        age: 30,
        height: 180.0,
        weight: 90.0,
        gender: Gender::Male,
        smoker: false
    };
    println!("抽烟吗？ {}", p.has_somoker());
    println!("bmi {}", Person::bmi(440.0, 90.0));
    print_person(p);
    let p = Person::new("charlotte".to_owned());
    println!("抽烟吗{:#?}", p.smoker);

}
