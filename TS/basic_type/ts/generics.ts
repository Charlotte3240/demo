function foo (arg : any){
    return arg
}

function foo1<T>(arg :T) : T{
    return arg
}

console.log(typeof foo1('asd'))
console.log(typeof foo1(123))
console.log(typeof foo1(false))
console.log(foo1<string>('charlotte'))


// 类型继承
function getLength<T extends string>(arg : T) : number{
    return arg.length //  any没有这个属性
}

function getMax<T extends number>(args :T[]) : number{
    let max = 0
    args.forEach((e)=>{
        if (e > max){
            max = e
        }
    })
    return max
}

console.log(getMax([1,3,4,5,6]))

// 更改为含有length属性的类型都可以使用
function getLengthFull<T extends {length : number}>(arg : T) : number{
    return arg.length
}
console.log(getLengthFull("first"))



class Collection <T> {
    data : T[] = []
    public push(...items :T[]){
        this.data.push(...items)
    }
    public shift(){
        return this.data.shift()
    }
}

