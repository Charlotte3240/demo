"use strict";
// // 断言
// // 枚举
// enum Sex{
//     MALE, // 男 0
//     FEMALE // 女 1
// }
// const stu = {
//     name : 'charlotte',
//     sex : Sex.MALE
// }
// console.log(stu)
// // as 断言
// function foo2 (arg : number) {
//     return arg ? 'charlotte' : 2022
// } 
// let strFoo : string = foo2(2) as string // as string 断言
// strFoo = <string>foo2(2)                // <string> 转换断言
// console.log(strFoo)
// // const 断言 表示最窄类型
// const constAssert = "charlotte" // 'charlotte' 类型 不是string 类型
// let user2 = 'hc' as const  // ’hc‘ 类型  不是string 类型
// // 只读属性
// let user3 = { name : 'hc'} as const
// // user3.name = '123' // as const 后变成只读，报错。
// // 只读属性变为 变量时 具体值为值类型
// let scores = [1,2,3,4,5] as const
// let s1 = scores[0] // : 1
// // s1 = 200 // 报错 
// console.log(s1)
// let cc = 'hc'
// let dd = 123
// let ccdd = [cc,dd] as const //let ccdd: readonly [string, number]
// let cd = ccdd[0] // : string
// cd = 'hdsad'
// console.log(cd)
// // 解构
// function hcFunc (){
//     let a = 'hc-nsqk.com'
//     let b = (x : number, y : number) :number => x + y
//     return [a,b]
// }
// let [f1 , f2] = hcFunc() // let f2: string | ((x: number, y: number) => number)
// // 这里f2 可以输入string 类型，有错误
// // f2 = 'asd'
// console.log((f2 as (x : number, y: number)=>number)(3,4)) // 先断言为后面的闭包类型，再传入数值
// // 或者这样子进行限制
// let [f3,f4] = hcFunc() as [string, (x : number, y:number) => number] // let f4: (x: number, y: number) => number
// console.log(f4(1,2))
// // 或者在函数体中进行限制
// function hcFuncLimitReturnType (){
//     let a = 'hc-nsqk.com'
//     let b = (x : number, y : number) :number => x + y
//     return [a,b] as [typeof a , typeof b]
// }
// let [f5,f6] = hcFuncLimitReturnType() // let f6: (x: number, y: number) => number
// console.log(f6(55,56))
// // 在函数题中 as const 进行限制
// function hcFuncAsConst(){
//     let a = 'hc-nsqk.com'
//     let b = (x : number, y : number) :number => x + y//() => {}
//     return [a,b] as const
// }
// let [f7,f8] = hcFuncAsConst() // let f8: (x: number, y: number) => number
// // 在严格null校验打开的情况下 不能讲 null undefined 赋值给其他类型，除非是 null| undefined | 其他类型的联合类型
// let hcc : string | undefined | null = undefined
// // 非空断言 使用! 代表非null
// // const el : HTMLDivElement = document.querySelector('.hc') as HTMLDivElement
// const el : HTMLDivElement = document.querySelector('.hc')! // ！把null 类型去掉 这样子赋值就不会报错了
// console.log(el)
// let aEle =  document.querySelector('.website') as HTMLAnchorElement
// console.log(aEle.href)
// let div : HTMLDivElement = document.querySelector('#charlotte')!
// console.log(div.id)
// const btn: HTMLButtonElement = document.querySelector('#btn')!
// btn.addEventListener('click', ()=>{
//     alert('btn click')
// })
