trait Description {
    fn describe(&self)->String;


    // 可以在 trait 中定义默认实现
    fn overview(&self)->String{
        String::from("Overview")
    }
}
#[derive(Debug,Clone)]
struct Objc{
    vars: Vec<String>
}

impl Description for Objc {
    fn describe(&self)->String {
        String::from(format!("Objective C has variables: {:?}", self.vars.join(",")))
    }

    // 在 impl 中覆盖默认实现
    fn overview(&self)->String {
        String::from("Overview of Objective C")
    }
}


fn call_obj(item: &dyn Description){
    println!("{}", item.describe());
}

fn call_obj_box(item: Box<dyn Description>){
    println!("{}", item.describe());
}


fn main() {
    let obj = Objc{
        vars: vec!["id".to_string(), "next".to_string()]
    };
    println!("{}", obj.describe());
    println!("{}", obj.overview());

    call_obj(&obj);
    println!("{:?}", obj);

    call_obj_box(Box::new(obj.clone()));
    println!("{:?}", obj);

    let goods:Vec<Box<dyn Discount>> = vec![Box::new(Good(10.0)), Box::new(Off20Good(100.0)), Box::new(Off50Good(300.0))];
    println!("{}", calculate_discount(goods));

    let goods =  vec![Off50Good(10.0), Off50Good(300.0)]; // 不使用Box 只能装入同一静态派发类型
    println!("{}", calculate_discount_goods(goods));

    let goods =  vec![Off50Good(10.0), Off50Good(300.0)];
    println!("{}", calculate_discount_goods_generic(goods));


    let hc_obj = HCNum{num: 10};
    let other_obj = HCNum{num: 3};
    let res_obj = cmd_combine_trait_obj(&hc_obj, &other_obj);
    println!("组合 trait {}", res_obj.num);
}


struct Good(f64);

trait Discount {
    fn amount(&self)->f64;
}

impl Discount for Good {
    fn amount(&self)->f64 {
        return self.0;
    }
}

struct Off20Good(f64);
impl Discount for Off20Good {
    fn amount(&self)->f64 {
        return self.0 * 0.8;
    }
}

struct Off50Good(f64);
impl Discount for Off50Good {
    fn amount(&self)->f64 {
        return self.0 * 0.5;
    }
}

fn calculate_discount(goods: Vec<Box<dyn Discount>>)->f64{
    return goods.iter().map(|g| g.amount()).sum();
}

fn calculate_discount_goods(goods: Vec<impl Discount>) -> f64{
    goods.iter().map(|e|e.amount()).sum()
}

fn calculate_discount_goods_generic<T:Discount>(goods: Vec<T>) -> f64{
    goods.iter().map(|e|e.amount()).sum()
}

// trait 组合

trait Addable {
    fn add(&self, other: &Self)->Self;
}

trait Droppable {
    fn drop(&self, other: &Self) -> Self;
}

struct HCNum{
    num: i32
}

impl Addable for HCNum {
    fn add(&self, other: &Self)->Self {
        return HCNum{
            num: self.num + other.num
        }
    }
}

impl Droppable for HCNum{
    fn drop(&self, other: &Self) -> Self {
        return HCNum{
            num: self.num - other.num
        }
    }
}

fn cmd_combine_trait_obj<T:Addable+Droppable>(obj: &T, other: &T) -> T{
    obj.add(other).drop(other).drop(other)
}
