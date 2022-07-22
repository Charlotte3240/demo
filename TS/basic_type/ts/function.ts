let hd = ()=>console.log('字符串')
hd()
// hd = '另外一个字符串' // 类型不匹配
hd = '另外一个字符串' as unknown as ()=>string
console.log(hd)

// 参数类型
function sum (a :number, b : number):number{
    return a+b
}

// 可选参数,没有传入的时候是undefined
function sum1 (a : number, b : number, ratio?:number) :number{
    console.log(ratio)
    return a+ b
}
console.log(sum1(1,2))

// 默认值，不需要可选，也可以不传
function sum2 (a : number, b: number, ratio:number = .8):number{
    return (a + b)*ratio
}

console.log(sum2(1,2))
// 没有返回值时 声明为 :void

// 函数定义
let func :() => void
// 函数实现
func = ():void => console.log("first")

type User = {
    name : string
    age : number
    class : number    
}
type addUserFunc = (user:User) => boolean

let addUser : addUserFunc = ((user:User) :boolean =>{
    return false
})

console.log(addUser({name:'',age:11,class:123}))

// 剩余参数

function sum3(...args :number[]): number{
    let result : number = 0
    // args.forEach(i => {
    //     result += i
    // })
    result = args.reduce((pre,cur,curIndex)=>{
        return pre + cur
    })

    return result
}

console.log(sum3(1,2,3,4))

function push(arr:any[],...args: any[]) :any[]{
    arr.push(...args)
    return arr
}

let arr1 : number[] = [1,2,3,4]
arr1 = push(arr1,2,5,9) as number[]
console.log(arr1)

// 元组  分为限制位置类型 和 不限制位置类型
let limitTuple : [string,number,boolean] = ['1',2,false] 
let unLimitTuple : (string | number | boolean)[] = [1,2,3,'dsa',false,22]

console.log(limitTuple,unLimitTuple)

// 函数重载 , 声明可以重载，实现不可以
function getData (id : number) :string;
function getData (id: string) :number;

function getData(id : unknown):any{

}