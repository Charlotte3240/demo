// import "reflect-metadata"
// 装饰器

// 1. 类装饰器      Class Decorator
// 2. 方法装饰器    Method Decorator
// 3. 属性装饰器    Property Decorator
// 4. 参数装饰器    Parameter Decorator

// 只能修饰类，不能修饰属性，方法，参数
type Constructor = new (...args: any[]) => {};
function LogTime<T extends Constructor>(target: T) {
  // 如果装饰器中 return 了 就会替换被修饰的类
  return class extends target {
    createdTime: Date;
    constructor(...args: any[]) {
      super(...args);
      this.createdTime = new Date();
    }
    getCreatedTime(): void {
      console.log(this.createdTime.toLocaleString());
    }
  };
}

@LogTime
class Person {
  constructor(public name: string, age: number) {}
}
interface Person {
  getCreatedTime(): void;
}

const p1 = new Person("charlotte", 18);
p1.getCreatedTime();

const MoveDecorator: ClassDecorator = (constructor: Function): void => {
  // 先执行装饰器，再执行其他方法
  console.log("Move class Decorator");
  constructor.prototype.getPosition = (): { x: number; y: number } => {
    return { x: 100, y: 100 };
  };
};

const MediaDecorator: ClassDecorator = (constructor: Function): void => {
  console.log("Music class Decorator");
  constructor.prototype.playNext = (): void => {
    console.log("play next sing");
  };
};

@MoveDecorator
@MediaDecorator
class Tank {
  public getPosition() {}
  // public playNext () {}
  constructor() {
    console.log("class constructor");
  }
}

const t = new Tank();
console.log((t as any).playNext());
console.log((<any>t).playNext());

MoveDecorator(Tank);
let t1: Tank = new Tank();
console.log(t1.getPosition());

const MessageDecorator: ClassDecorator = (constructor: Function): void => {
  constructor.prototype.message = (msg: string) => {
    let ele = document.createElement("h2");
    ele.innerText = `${msg}`;
    document.body.insertAdjacentElement("afterbegin", ele);
  };
};

@MessageDecorator
class LoginController {
  login() {
    console.log("登录逻辑");
    (<any>this).message("login success");
  }
}

const loginVc = new LoginController();
loginVc.login();

//MARK: - 装饰器工厂
const MusicDecorator = (type: string): ClassDecorator => {
  switch (type) {
    case "player":
      return (constructor: Function) => {
        constructor.prototype.play = (): void => {
          console.log(`play player's sing`);
        };
      };

    default:
      return (constructor: Function) => {
        constructor.prototype.play = (): void => {
          console.log(`play other sing`);
        };
      };
  }
};

@MusicDecorator("o")
class Webpage {
  constructor() {}
}
const web = new Webpage();
console.log((<any>web).play());

console.log("Method Decorator");
//MARK: - 方法装饰器
/*
 * 方法装饰器有三个参数
 * 1. target : 普通方法是构造参数的原型对象Prototype ， 静态方法是构造函数
 * 2. 方法名称
 * 3. 属性描述
 * */
const ShowDecorator: MethodDecorator = (
  target: object,
  propertyKey: string | symbol,
  descriptor: PropertyDescriptor
): void => {
  console.log("normal method decorator");
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
    console.log("charlotte descriptor");
  };
};

const ShowStaticDecorator: MethodDecorator = (
  target,
  propertyKey,
  descriptor
): void => {
  console.log("static method decorator");
  //对象
  console.dir(target);
  //方法名称
  console.dir(propertyKey);
  //属性描述
  console.dir(descriptor);
  descriptor.writable = false;
};

class Charlotte {
  @ShowDecorator
  show() {
    console.log("show method");
    alert("test");
  }
  @ShowStaticDecorator
  static present() {
    console.log("present method");
  }
}

const c = new Charlotte();
c.show();
// 重写方法体
// c.show = () =>{
//     console.log('reload method')
// }
// c.show()

Charlotte.present();

const HighlightCodeDecorator: MethodDecorator = (
  target,
  propertyKey,
  descriptor: PropertyDescriptor
): void => {
  const originValue = descriptor.value;
  descriptor.value = () => {
    return `<div style="color: red">${originValue()}</div>`;
  };
  descriptor.writable = false;
};

class CodeSample {
  @HighlightCodeDecorator
  codeLineDisplay() {
    return "code show";
  }
}

const codeSample = new CodeSample();
document.body.insertAdjacentHTML("afterend", codeSample.codeLineDisplay());

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

const DelayMethod =
  (time: number): MethodDecorator =>
  (...args: any[]) => {
    const [, , descriptor] = args;
    const method = descriptor.value;
    descriptor.value = () => {
      setTimeout(() => {
        method();
      }, time * 1000);
    };
  };

class User {
  @DelayMethod(3)
  public delayTest() {
    console.log("delay function print", new Date().getTime());
  }
}

const u = new User();
console.log(new Date().getTime());
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
const ErrorDecorator =
  (title: string, message: string): MethodDecorator =>
  (target, propertyKey, descriptor: PropertyDescriptor) => {
    const method = descriptor.value;
    descriptor.value = () => {
      try {
        method();
      } catch (e: any) {
        console.log(
          `%c${title || "hc-nsqk.com charlotte"}`,
          "color:green;font-size:20px;"
        );
        console.log(`%c${message || e.message}`, "color:red;font-size:20px;");
        console.log(`%c${e.stack}`, "color:blue;font-size:20px;");
      }
    };
  };

class ErrorClass {
  @ErrorDecorator("tile", "message")
  showErr() {
    throw new Error("custom erorr");
  }
}

const errClass = new ErrorClass();
errClass.showErr();

const user = {
  name: `charlotte`,
  signed: true,
  permissions: ["store", "message"],
};

// 登陆验证
const AccessDecorator: MethodDecorator = (
  target,
  propertyKey,
  descriptor: PropertyDescriptor
) => {
  const method = descriptor.value;
  descriptor.value = () => {
    if (user.signed) {
      return method();
    } else {
      location.href = `https://www.ivy4ever.com`;
    }
  };
};

//模块权限验证
const PermissionDecorator = (permission: string[]): MethodDecorator => {
  return (target, propertyKey, descriptor: PropertyDescriptor) => {
    const method = descriptor.value;
    const validate = permission.every((v, index, array) => {
      return user.permissions.includes(v);
    });
    descriptor.value = () => {
      if (user.signed && validate) {
        return method();
      } else {
        alert(`need login or permission is invalid`);
        location.href = `https://www.ivy4ever.com`;
      }
    };
  };
};

class MessageCenter {
  @AccessDecorator
  showMessage() {
    console.log(`show message`);
  }
  signOut() {
    user.signed = false;
  }
  // 需要message 、store的权限才可以执行这个方法，否则进行拦截
  @PermissionDecorator([`message`, `store`])
  showStore() {
    console.log(`show store`);
  }
}

const msgCenter = new MessageCenter();
msgCenter.showMessage();
// msgCenter.signOut()
// msgCenter.showMessage()

msgCenter.showStore();

// 网络异步请求装饰器
const RequestDecorator = (url: string): MethodDecorator => {
  return (target, propertyKey, descriptor: PropertyDescriptor) => {
    const method = descriptor.value;
    new Promise<any>((resolve) => {
      setTimeout(() => {
        resolve([{ name: "charlotte" }, { name: `hc-nsqk` }]);
      }, 2000);
    }).then((user) => {
      method(user);
    });
  };
};

class UserList {
  @RequestDecorator(`https://www.ivy4ever.com/getUsers`)
  getUser(user: any[]) {
    console.log(JSON.stringify(user));
  }
}

const userList = new UserList();
userList.getUser([{ name: "all" }]);

//MARK: - 属性装饰器
/*
 * 比方法装饰器少一个descriptor参数
 * 1.target: 普通方法是构造函数的原型对象Prototype, 静态方法是构造函数
 * 2.propertyKey: 属性名称
 * */
const PropertyDecorator: PropertyDecorator = (target, propertyKey) => {
  console.log(`target:`, target);
  console.log(`propertyKey:`, propertyKey);
};

class PropertyClass {
  @PropertyDecorator
  public name: string | undefined = `charlotte`;
}
const propertyCls = new PropertyClass();
console.log("property decorator", propertyCls.name);
propertyCls.name = `hc-nsqk`;
console.log("property decorator", propertyCls.name);

const RandomPropertyDecorator: PropertyDecorator = (target, propertyKey) => {
  const colors: string[] = ["red", "green", "blue", "#333"];
  Object.defineProperty(target, propertyKey, {
    get: () => {
      return colors[Math.floor(Math.random() * colors.length)];
    },
  });
};
class ColorCls {
  @RandomPropertyDecorator
  public color: string | undefined;

  public draw() {
    document.body.insertAdjacentHTML(
      "beforeend",
      `<div style="display: inline-block;width: 200px;height:200px;background-color: ${this.color}">charlotte</div>`
    );
  }
}
console.log("color decorator");
const colorCls = new ColorCls();
for (var i = 0; i < 10; i++) {
  colorCls.draw();
}
console.log("color decorator end");

//参数装饰器
/*
 * 对方法中对参数设置装饰器,参数装饰器的返回参数被忽略
 * 1. 普通方法是构造函数中的原型对象Prototype, 静态方法是构造函数
 * 2. 方法名称
 * 3. 参数所在索引位置
 * */

const HCParamDecorator: ParameterDecorator = (
  target,
  propertyKey,
  parameterIndex
) => {
  console.log(`ParamterDecorator`);
  console.log(target, propertyKey, parameterIndex);
};

class HCParam {
  encode(@HCParamDecorator args: string[]) {}
}

const hcParam = new HCParam();
hcParam.encode([`charlotte`, `hc-nsqk`]);

// const hc = {name:'charlotte',city : `shanghai`}
//
// Reflect.defineMetadata('xj','nsqk.com',hc,'name')
//
// let value = Reflect.getMetadata('xj',hc)
//
// console.log(value)

// 先从上到下执行装饰器工厂， 再从下到上执行装饰器
// 执行顺序为  test2工厂方法 -> test3工厂方法 -> test4方法 -> test3方法 -> test2方法 -> test1方法
// @test1
// @test2()
// @test3()
// @test4
// class HC{}

function sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function StopWatch(
  target: object,
  propertyKey: string,
  descriptor: PropertyDescriptor
) {
  let originMethod = descriptor.value;
  let startDate = new Date();
  descriptor.value = function (...args: any[]) {
    console.log(`stopwatch ${propertyKey} start`);
        // const result = originMethod.call(this, ...args) // call 和 apply 区别， call 参数要一个一个传入，apply 可以传入一个数组
    const result = originMethod.apply(this, args);
    console.log(
        `stopwatch ${propertyKey} end ${new Date().getTime() - startDate.getTime()}`
      );
    return result;
  };


}

class HC {
  @StopWatch
  fooFunction() {
    console.log("foo function");
  }
}

let hc = new HC();
hc.fooFunction();