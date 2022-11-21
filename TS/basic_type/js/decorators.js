"use strict";
// import "reflect-metadata"
// 装饰器
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
// 1. 类装饰器      Class Decorator
// 2. 方法装饰器    Method Decorator
// 3. 属性装饰器    Property Decorator
// 4. 参数装饰器    Parameter Decorator
const MoveDecorator = (constructor) => {
    // 先执行装饰器，再执行其他方法
    console.log('Move class Decorator');
    constructor.prototype.getPosition = () => {
        return { x: 100, y: 100 };
    };
};
const MediaDecorator = (constructor) => {
    console.log("Music class Decorator");
    constructor.prototype.playNext = () => {
        console.log("play next sing");
    };
};
let Tank = class Tank {
    getPosition() { }
    // public playNext () {}
    constructor() {
        console.log('class constructor');
    }
};
Tank = __decorate([
    MoveDecorator,
    MediaDecorator,
    __metadata("design:paramtypes", [])
], Tank);
const t = new Tank();
console.log(t.playNext());
console.log(t.playNext());
MoveDecorator(Tank);
let t1 = new Tank();
console.log(t1.getPosition());
const MessageDecorator = (constructor) => {
    constructor.prototype.message = (msg) => {
        let ele = document.createElement('h2');
        ele.innerText = `${msg}`;
        document.body.insertAdjacentElement('afterbegin', ele);
    };
};
let LoginController = class LoginController {
    login() {
        console.log('登录逻辑');
        this.message('login success');
    }
};
LoginController = __decorate([
    MessageDecorator
], LoginController);
const loginVc = new LoginController();
loginVc.login();
//MARK: - 装饰器工厂
const MusicDecorator = (type) => {
    switch (type) {
        case 'player':
            return (constructor) => {
                constructor.prototype.play = () => {
                    console.log(`play player's sing`);
                };
            };
        default:
            return (constructor) => {
                constructor.prototype.play = () => {
                    console.log(`play other sing`);
                };
            };
    }
};
let Webpage = class Webpage {
    constructor() {
    }
};
Webpage = __decorate([
    MusicDecorator('o'),
    __metadata("design:paramtypes", [])
], Webpage);
const web = new Webpage();
console.log(web.play());
console.log('Method Decorator');
//MARK: - 方法装饰器
/*
* 方法装饰器有三个参数
* 1. target : 普通方法是构造参数的原型对象Prototype ， 静态方法是构造函数
* 2. 方法名称
* 3. 属性描述
* */
const ShowDecorator = (target, propertyKey, descriptor) => {
    console.log('normal method decorator');
    //对象
    console.dir(target);
    //方法名称
    console.dir(propertyKey);
    //属性描述
    console.dir(descriptor);
    // 禁止写入
    descriptor.writable = false;
    // 覆盖方法的方法体
    descriptor.value = () => {
        console.log('charlotte descriptor');
    };
};
const ShowStaticDecorator = (target, propertyKey, descriptor) => {
    console.log('static method decorator');
    //对象
    console.dir(target);
    //方法名称
    console.dir(propertyKey);
    //属性描述
    console.dir(descriptor);
    descriptor.writable = false;
};
class Charlotte {
    show() {
        console.log('show method');
        alert('test');
    }
    static present() {
        console.log('present method');
    }
}
__decorate([
    ShowDecorator,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], Charlotte.prototype, "show", null);
__decorate([
    ShowStaticDecorator,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], Charlotte, "present", null);
const c = new Charlotte();
c.show();
// 重写方法体
// c.show = () =>{
//     console.log('reload method')
// }
// c.show()
Charlotte.present();
const HighlightCodeDecorator = (target, propertyKey, descriptor) => {
    const originValue = descriptor.value;
    descriptor.value = () => {
        return `<div style="color: red">${originValue()}</div>`;
    };
    descriptor.writable = false;
};
class CodeSample {
    codeLineDisplay() {
        return 'code show';
    }
}
__decorate([
    HighlightCodeDecorator,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], CodeSample.prototype, "codeLineDisplay", null);
const codeSample = new CodeSample();
document.body.insertAdjacentHTML('afterend', codeSample.codeLineDisplay());
// const DelayMethod: MethodDecorator = (
// target, propertyKey, descriptor: PropertyDescriptor) =>{
//     const method = descriptor.value
//     descriptor.value = ()=>{
//         setTimeout(()=>{
//             method()
//         },2000)
//     }
// }
// const MusicDecorator = (type : string): ClassDecorator => {
const DelayMethod = (time) => (...args) => {
    const [, , descriptor] = args;
    const method = descriptor.value;
    descriptor.value = () => {
        setTimeout(() => {
            method();
        }, time * 1000);
    };
};
class User {
    delayTest() {
        console.log('delay function print', ((new Date()).getTime()));
    }
}
__decorate([
    DelayMethod(3),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], User.prototype, "delayTest", null);
const u = new User();
console.log((new Date()).getTime());
u.delayTest();
// 自定义错误
// const ErrorDecorator : MethodDecorator = (
//     target, propertyKey, descriptor:PropertyDescriptor)=>{
//     const method = descriptor.value
//     descriptor.value = () =>{
//         try {
//             method()
//         }catch (err :any) {
//             //%c 为了后面css样式占位
//             console.log(`%chc-nsqk.com charlotte`,"color:green;font-size:20px;")
//             console.log(`%c${err.message}`,"color:red;font-size:20px;")
//             console.log(`%c${err.stack}`,"color:blue;font-size:20px;")
//
//         }
//     }
// }
// 装饰器工厂
const ErrorDecorator = (title, message) => (target, propertyKey, descriptor) => {
    const method = descriptor.value;
    descriptor.value = () => {
        try {
            method();
        }
        catch (e) {
            console.log(`%c${title || "hc-nsqk.com charlotte"}`, "color:green;font-size:20px;");
            console.log(`%c${message || e.message}`, "color:red;font-size:20px;");
            console.log(`%c${e.stack}`, "color:blue;font-size:20px;");
        }
    };
};
class ErrorClass {
    showErr() {
        throw new Error("custom erorr");
    }
}
__decorate([
    ErrorDecorator("tile", "message"),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ErrorClass.prototype, "showErr", null);
const errClass = new ErrorClass();
errClass.showErr();
const user = {
    name: `charlotte`,
    signed: true,
    permissions: ["store", "message"]
};
// 登陆验证
const AccessDecorator = (target, propertyKey, descriptor) => {
    const method = descriptor.value;
    descriptor.value = () => {
        if (user.signed) {
            return method();
        }
        else {
            location.href = `https://www.ivy4ever.com`;
        }
    };
};
//模块权限验证
const PermissionDecorator = (permission) => {
    return (target, propertyKey, descriptor) => {
        const method = descriptor.value;
        const validate = permission.every((v, index, array) => {
            return user.permissions.includes(v);
        });
        descriptor.value = () => {
            if (user.signed && validate) {
                return method();
            }
            else {
                alert(`need login or permission is invalid`);
                location.href = `https://www.ivy4ever.com`;
            }
        };
    };
};
class MessageCenter {
    showMessage() {
        console.log(`show message`);
    }
    signOut() {
        user.signed = false;
    }
    // 需要message 、store的权限才可以执行这个方法，否则进行拦截
    showStore() {
        console.log(`show store`);
    }
}
__decorate([
    AccessDecorator,
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], MessageCenter.prototype, "showMessage", null);
__decorate([
    PermissionDecorator([`message`, `store`]),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], MessageCenter.prototype, "showStore", null);
const msgCenter = new MessageCenter();
msgCenter.showMessage();
// msgCenter.signOut()
// msgCenter.showMessage()
msgCenter.showStore();
// 网络异步请求装饰器
const RequestDecorator = (url) => {
    return (target, propertyKey, descriptor) => {
        const method = descriptor.value;
        new Promise(resolve => {
            setTimeout(() => {
                resolve([{ name: "charlotte" }, { name: `hc-nsqk` }]);
            }, 2000);
        }).then(user => {
            method(user);
        });
    };
};
class UserList {
    getUser(user) {
        console.log(JSON.stringify(user));
    }
}
__decorate([
    RequestDecorator(`https://www.ivy4ever.com/getUsers`),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Array]),
    __metadata("design:returntype", void 0)
], UserList.prototype, "getUser", null);
const userList = new UserList();
userList.getUser([{ name: 'all' }]);
//MARK: - 属性装饰器
/*
* 比方法装饰器少一个descriptor参数
* 1.target: 普通方法是构造函数的原型对象Prototype, 静态方法是构造函数
* 2.propertyKey: 属性名称
* */
const PropertyDecorator = (target, propertyKey) => {
    console.log(`target:`, target);
    console.log(`propertyKey:`, propertyKey);
};
class PropertyClass {
    constructor() {
        this.name = `charlotte`;
    }
}
__decorate([
    PropertyDecorator,
    __metadata("design:type", Object)
], PropertyClass.prototype, "name", void 0);
const propertyCls = new PropertyClass();
console.log('property decorator', propertyCls.name);
propertyCls.name = `hc-nsqk`;
console.log('property decorator', propertyCls.name);
const RandomPropertyDecorator = (target, propertyKey) => {
    const colors = ['red', 'green', 'blue', '#333'];
    Object.defineProperty(target, propertyKey, {
        get: () => {
            return colors[Math.floor(Math.random() * colors.length)];
        }
    });
};
class ColorCls {
    draw() {
        document.body.insertAdjacentHTML('beforeend', `<div style="display: inline-block;width: 200px;height:200px;background-color: ${this.color}">charlotte</div>`);
    }
}
__decorate([
    RandomPropertyDecorator,
    __metadata("design:type", Object)
], ColorCls.prototype, "color", void 0);
console.log('color decorator');
const colorCls = new ColorCls();
for (var i = 0; i < 10; i++) {
    colorCls.draw();
}
console.log('color decorator end');
//参数装饰器
/*
* 对方法中对参数设置装饰器,参数装饰器的返回参数被忽略
* 1. 普通方法是构造函数中的原型对象Prototype, 静态方法是构造函数
* 2. 方法名称
* 3. 参数所在索引位置
* */
const HCParamDecorator = (target, propertyKey, parameterIndex) => {
    console.log(`ParamterDecorator`);
    console.log(target, propertyKey, parameterIndex);
};
class HCParam {
    encode(args) {
    }
}
__decorate([
    __param(0, HCParamDecorator),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Array]),
    __metadata("design:returntype", void 0)
], HCParam.prototype, "encode", null);
const hcParam = new HCParam();
hcParam.encode([`charlotte`, `hc-nsqk`]);
// const hc = {name:'charlotte',city : `shanghai`}
//
// Reflect.defineMetadata('xj','nsqk.com',hc,'name')
//
// let value = Reflect.getMetadata('xj',hc)
//
// console.log(value)
