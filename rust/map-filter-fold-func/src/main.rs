fn main() {
    let arr = vec![1,2,3];
    let res :Vec<_> = arr.iter().map(|item|item *2).collect();
    println!("{:?}", res);


    let res = arr.iter().filter(|&item|item % 2 == 0).collect::<Vec<_>>();
    println!("{:?}", res);

    let res = arr.iter().fold(0, |a, &b| a + b);
    println!("{}", res);

}
