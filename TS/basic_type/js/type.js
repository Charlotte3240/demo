"use strict";
// // 字符串
// const str: string = "hello world"
// // 数值
// const num : number = 123.123
// // 布尔值
// const isValid : boolean = false
// // 数组
// const nums : Number[] = [1,2,3]
// const arr : string[] = ['a','b','abc']
// let arr2 = new Array<string>(3).fill('hello')
// console.log(arr,arr2,nums)
// // 元祖
// let tuple1 : [string , number, boolean] = ["a",123,false]
// console.log(tuple1)
// // 枚举 0 1 2 
// enum Color {red , yellow, green}
// let c1 = Color.green
// console.log(c1)
// // 对象
// let dic : object = {
//     name : 'ddsad'
// }
// console.log(dic)
// // js中 数组，function 都是对象,可以互换
// dic = function (){}
// dic = []
// dic = {}
// // 接口
// interface IWSMessage {
//     decode(params:string):string
//     name : string
//     title : string
// }
// let foo : IWSMessage = {
//     decode:(params: string) => {return "hello world "},
//     name : "name",
//     title: "title"
// }
// // 索引签名
// type WSMsg = {
//     id : string
//     sceneId : string
// }
// let initMsg : WSMsg = {
//     id: "init",
//     sceneId: "100"
// }
// type cmds = 'stop' | 'hangup'
// type Message = {
//     [key in cmds] : object
// }
// let msg : Message ={
//     stop : {
//         name : 'stop'
//     },
//     hangup : {
//         name : 'hangup'
//     },
// }
// console.log(msg.stop,msg.hangup)
// type AnyType = {
//     // value 可以是任意类型
//     [key:string] : keyof any
// }
// let obj1 : AnyType = {
//     dadas:12,
//     assad:'objc'
// }
// console.log(obj1)
// let r1 :Record<string | number, number> = {
//     name : 13,
//     13  :143
// }
// let r2 : Record<'age'| 'name'|'city',string> = {
//     age :"123",
//     name:"dsad",
//     city:"shanghai"
// }
// console.log(r2)
// r2.age = '1233'
// console.log(r2)
// // any 类型 不会进行类型检查 可以设置tsconfig中的 noImplicitAny 为true来禁止隐含的any 类型
// let hc :any = 123
// let hcArr : any[] = [123,2321]
// let hcArr1 : Array<any>
// // console.log(hc.getxxx()) // 编译不会报错
// // unknown 类型 会进行类型检查 可以类似swift as 来转换类型
// // 可以任何类型的值赋值给 unknown类型， 需要计算的时候再进行转换
// let gsd : unknown = "**==="
// let kaili : string = gsd as string //不能将类型“unknown”分配给类型“string”。ts(2322)
// let shalan : number = gsd as number
// console.log(typeof(shalan))
// console.log(100 + (gsd as number)) // 需要转换好类型 再进行计算
// // console.log(str as number) // 不能直接吧string as 成number，需要中间先转一层unknown
// console.log(str as unknown as number) 
// // keyof 获取所有键值的联合类型
// type HC<T> = {[key in keyof T]: string}
// type Person = HC<any>
// type XX  = HC<unknown>
// let hc1 : HC<string> = 'dasd'
// // void 类型，值为null 或 undefine, 严格模式中只能是undefine
// let a : void = undefined
// console.log(a)
// function foo1 () : void{
//     // return 'ddd' // 声明void 后不能有返回值,或者返回undefine
//     // return void
//     console.log("foo1")
//     return undefined
// }
// foo1()
// // never 类型
// // never是任何类型的子类型， never类型中没有任何值
// // 函数抛出异常或无限循环时返回值是 never
// function show():never{
//     throw new Error('found an error with return value ')
// }
// // show()
// type neverDemo = never extends string ? string : boolean
// let d : neverDemo = '123'
// type neverDemo2 = never | string | number // string | number 类型
// let d2 : neverDemo2 = 'dsad'
// console.log(typeof(d), typeof(d2))
// // null 和 undefine 类型
// let nullT : null = null
// let undefineT : undefined = undefined
// console.log(nullT,undefineT)
// function getName () : string | null{
//     return null
// }
// // let test : string = undefined // 在开启strictNullChecks 后 null、undefined只能赋值给void null undefined
// // let test1 : void = undefined
// // let test2 : undefined = undefined
// // union 联合类型
// let uType: string | number = 123
// uType = '12345'
// console.log(uType)
// let uTypeArr : (string | number | boolean) [] = [123,'dsa',false]
// let uTypeArr2 : Array<string| number | boolean> = [1233,true, 'dsadasdsa']
// uTypeArr2.push('charlotte')
// console.log(uTypeArr,uTypeArr2)
// // 对于union类型的处理
// type HCType = string | number
// function dealWith (hc : boolean | HCType){
//     if (typeof hc === 'boolean'){
//         return hc ? "true str" : 'false str'
//     }else{
//         return hc
//     }
// }
// console.log(dealWith(false))
// console.log(dealWith(123))
// // 交叉类型
// type Candidate = {
//     ip :string
//     candidate : string[]
// }
// type MediaInfo = {
//     video: object
//     audio : object
// }
// type Sdp = Candidate & MediaInfo
// let sdp1 : Sdp = {
//     ip: '192.168.1.1',
//     candidate : ['dsajdklsaj'],
//     video:{
//         height : 1280,
//         width : 720
//     },
//     audio:{
//         codec:'opus'
//     }
// }
// console.log(sdp1)
// type errorCombine = string & boolean
// // let eInstance :errorCombine = undefined // string & boolean 合并后是never类型
// // Pick 类型工具 ， 保留pick出来的类型
// let v = {name :'charlotte'}
// let b = {name :'hc',age:18}
// type vb = typeof v & Pick<typeof b, 'age'>
// type vb2 = typeof v & Omit<typeof b , 'name'> // 忽略类型
// let vbInstance : vb = {
//     name:'chaelotte',
//     age:111
// }
// let vbInstance2 : vb2 = {
//     name:'chaelotte',
//     age:111
// }
// console.log(vbInstance,vbInstance2)
// // 联合类型交叉
// type UCombineT1 = ('a' | 'b') & ('a') // 'a'
// let uc1 : UCombineT1 = 'a'
// console.log(typeof uc1) // string
// type UCombineT2 = ('a'|'b') &('a' | string) // 'a' | 'b'
// let uc2 : UCombineT2 = 'a' //不能把d设置到uc2上去 ，类型只有 a或b
// console.log(typeof uc2)
