// 装饰器

// 1. 类装饰器      Class Decorator
// 2. 方法装饰器    Method Decorator
// 3. 属性装饰器    Property Decorator
// 4. 参数装饰器    Parameter Decorator

const MoveDecorator : ClassDecorator = (constructor : Function) :void => {
    // 先执行装饰器，再执行其他方法
    console.log('类装饰器')
}

@MoveDecorator
class Tank{
    constructor(){
        console.log('class constructor')
    }
}

let t = new Tank()
