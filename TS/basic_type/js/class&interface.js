"use strict";
// // 修饰关键词
// // public 修饰属性和方法,默认选项
// // protected 只允许在父类和子类中shiyongs
// // private 只能在当前类使用
// // readonly 只读，哪里都不能改
// class User {
//     public name : string
//     protected sex : boolean
//     private age : number
//     readonly idNum : number = 123456
//     constructor(name : string, sex : boolean, age : number){
//         this.name = name
//         this.sex = sex
//         this.age = age
//     }
//     info(): string{
//         return `${this.name} ${this.sex ? 'male':'female'} ${this.age} ${this.idNum}`
//     }
// }
// let u = new User('charlotte',false,18)
// //属性“age”为私有属性，只能在类“User”中访问。ts(2341) 但是js中还是可以用
// console.log(u.info()) 
// // console.log(u.age,u.sex)
// for (const key in u) {
//     if (Object.prototype.hasOwnProperty.call(u, key)) {
//         console.log(key)
//     }
// }
// let arr : User[] = [u]
// console.log(arr)
// class Stu extends User{
//     private classId : string
//     constructor(c_id : string){
//         super('hc',false,15)
//         this.sex = true
//         this.classId = c_id
//     }
// }
// let s : Stu = new Stu('1-1')
// // s.idNum = 456
// // console.log(s.age,s.sex,s.idNum)
// console.log(s)
// console.log(s.info())
// class Customer extends User{
//     // ts中可以直接在constructor中写属性
//     constructor(
//         public update_at : number,
//         readonly create_at: number = new Date().getTime()
//     ){
//         super('customer_name',false,11)
//     }
// }
// let c : Customer = new Customer(123456789)
// console.log(c.info(),c.create_at,c.update_at)
// // static 关键字
// class Goods {
//     private _name : string = ''
//     static url : string = 'ivy4ever.com'
//     static getSiteInfo (): string{
//         return '其他文件在' + Goods.url
//     }
//     public get name() : string {
//         return this._name
//     }
//     public set name(v : string) {
//         this._name = v;
//     }
// }
// let g : Goods = new Goods()
// g.name = 'set string value'
// console.log('get string value ' + g.name)
// console.log(Goods.getSiteInfo())
// // 单例模式
// class Shared {
//     static instance : Shared | null = null
//     protected constructor(){
//     }
//     static Instance(): Shared{
//         if (Shared.instance == null){
//             Shared.instance = new Shared()
//         }
//         return Shared.instance!
//     }
// }
// // let share : Shared = new Shared() // constructor是 protected 只能在内部实例化
// console.log(Shared.Instance())
// let localIds :string[] = ['2ff2c04f4126c6f6',
// '612e9e7cd21a22b8',
// 'de64923ebd813706',
// '08d922963baaeea2',
// 'f815cbad3f8ee721',
// '37922b353f0bf228',
// 'd0077b804a3f0c87',
// '4f1cc289bfe56743',
// 'eb09b14c92ae5870',
// '30b1a2bcb27a146f',
// 'd414464649bf61ee',
// '2e6ffb0d96ad81b6',
// '3e9601aba3d7a4ca',
// '8c2cee884e62e8af',
// 'fd74ffd96b5c4537',
// 'dd6e6f777703ddd5',
// 'a93854d4445410ba',
// '778141c739689bb0',
// '03fdb21e32eb30e1']
// // abstract 抽象 ，对比普通的class 多了abstract方法
// /*
//     1. 抽象类可以不包含抽象方法，但抽象方法一定在抽象类中
//     2. 抽象方法是对方法的定义，子类必须实现这个方法
//     3. 抽象类不能直接使用，只能被继承   
//     4. 类似于模版
// */
// abstract class Animation1{
//     abstract name : string
//     abstract move(): void
//     protected getPos(): object{
//         return{
//             x : 100,
//             y : 100
//         }
//     }
// }
// class FadeIn extends Animation1{
//     name: string = 'FadeIn';
//     move(): void {
//         console.log('move function called')
//     }
// }
// let f : FadeIn = new FadeIn()
// console.log(f.name)
// console.log(f.move())
// // interface
// // 描述类和对象的结构
// interface AnimationInterface{
//     name : string
//     move():void
// }
// abstract class Animation2{
//     protected getPos () : {x:number, y : number}{
//         return {x:100,y:100}
//     }
// }
// class FadeOut extends Animation2 implements AnimationInterface{
//     newVars: number = 123
//     name: string = 'name is xxx'
//     move(){
//         console.log('move')
//     }
// }
// let f2 : FadeOut = new FadeOut()
// console.log(f2.move())
// // 接口用来约束对象
// interface Student {
//     classId : string
//     age : number
//     // 接口类型的对象不能随意增加属性，除非加上下面的
//     [key : string] : any
// }
// let stu1 : Student = {
//     classId:'ddd',
//     age : 11,
//     "other" : 'other value'
// }
// console.log(stu1)
// // 接口继承
// interface BaseHandler{
//     name () : string
//     start () : Error | null
//     stop () : Error | null
// }
// interface ComponentHandler extends BaseHandler{
//     src : string
//     input (data : Uint8Array) : Error | null
//     // output (data : Uint8Array , err?: Error) : void
//     output(callback:(data: Uint8Array, err?: Error)=>void): void 
// }
// interface SessionRequire{
//     close():void
// }
// // 可以实现多个接口
// class AliAsr implements ComponentHandler , SessionRequire{
//     close(): void {
//         console.log('notify close session')
//     }
//     input(data: Uint8Array): Error | null{
//         if (data.length > 0){
//             this.output(()=>{})
//             return null
//         }
//         throw new Error('input data length < 0')
//     }
//     output(callback:(data: Uint8Array, err?: Error)=>void): void {
//         callback(Uint8Array.from([1,2,3]))
//     }
//     name(): string {
//         return "aliAsr"
//     }
//     start(): Error | null {
//         return null
//     }
//     stop(): Error | null {
//         return null
//     }
//     src: string = 'ali'
// }
// let a : AliAsr = new AliAsr()
// a.input(Uint8Array.from([1,2,3]))
// // a.input(Uint8Array.from([]))
// a.output((data,err)=>{
//     console.log('output callback')
//     console.log(data,err)
// })
// //可以使用接口对函数参数进行类型约束
// interface UserInterface{
//     name : string
//     age : number
//     isLock : boolean
// }
// function lockUser(user : UserInterface ,state : boolean ) : UserInterface{
//     user.isLock = state
//     return user
// }
// // 函数声明
// interface  Pay {
//     (price : number) : boolean
// }
// const getUserInfo : Pay = (price : number) => false // 约束类型
// // type
// // 和interface 类似 都可以描述一个对象或函数
// // type 更加灵活一些
// // type 可以定义联合类型或元组
// type UserType = {
//     name : string
//     age : number
// }
// const u1 : UserType = {
//     name: 'charlotte',
//     age: 11
// }
// console.log(u1)
// // type还可以给已有的类型起别名 相当于 alias
// type NewTypeFormAlready = UserType
// const newType : NewTypeFormAlready = {
//     name : 'hc',
//     age : 899
// }
// console.log(newType)
// // 联合类型
// type  unionType = string | number
// // 声明继承
// // 声明两个相同的interface 会进行合并， 同名的type是不被允许的
// // type User ={ //标识符“User”重复。ts(2300)
// // }
// /*
// interface AnimationInterface{
//     name : string
//     move():void
// }
// */
// interface AnimationInterface{
//     newVars : number
// }
// const o1 : AnimationInterface = {
//     newVars : 1,
//     name : '456das',
//     move() {
//         console.log('move')
//     },
// }
// console.log(o1)
// // interface 可以extends type
// type extensType = {
//     name : string
// }
// interface extendTypeInterface extends extensType{
//     age : number
// }
// const e1 : extendTypeInterface = {
//     name : 'dsa',
//     age: 11
// }
// console.log(e1)
// // type 类型合并 两个interface
// interface interface1 {
//     name : string
// }
// interface interface2{
//     age : number
// }
// type combineInterfaceType = interface1 & interface2
// // type 合并两个type声明
// type type1 = {
//     name : string
// }
// type type2 = {
//     age : number
// }
// type combineTypesType = type1 & type2
// const c1 : combineTypesType  = {
//     name:" dsa",
//     age:123
// }
// console.log("combine types ",c1)
// // type 共用体
// type u1 = type1 | type2
// const unionTypes : u1 = {
//     age:123,
//     // name : '22'
// }
// console.log('实现其中一个type就可以',unionTypes)
// // 实现接口或者type
// interface needImpIni {
//     name : string
// }
// type needImpType= {
//     age : number
// }
// class ImpTypeAndIni implements needImpIni, needImpType{
//     age: number 
//     name: string
//     constructor(name : string, age : number){
//         this.name = name
//         this.age = age
//     }
// }
