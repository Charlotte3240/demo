"use strict";
// 字符串
const str = "hello world";
// 数值
const num = 123.123;
// 布尔值
const isValid = false;
// 数组
const nums = [1, 2, 3];
const arr = ['a', 'b', 'abc'];
let arr2 = new Array(3).fill('hello');
console.log(arr, arr2, nums);
// 元祖
let tuple1 = ["a", 123, false];
console.log(tuple1);
// 枚举 0 1 2 
var Color;
(function (Color) {
    Color[Color["red"] = 0] = "red";
    Color[Color["yellow"] = 1] = "yellow";
    Color[Color["green"] = 2] = "green";
})(Color || (Color = {}));
let c1 = Color.green;
console.log(c1);
// 对象
let dic = {
    name: 'ddsad'
};
console.log(dic);
// js中 数组，function 都是对象,可以互换
dic = function () { };
dic = [];
dic = {};
let foo = {
    decode: (params) => { return "hello world "; },
    name: "name",
    title: "title"
};
let initMsg = {
    id: "init",
    sceneId: "100"
};
let msg = {
    stop: {
        name: 'stop'
    },
    hangup: {
        name: 'hangup'
    },
};
console.log(msg.stop, msg.hangup);
let obj1 = {
    dadas: 12,
    assad: 'objc'
};
console.log(obj1);
let r1 = {
    name: 13,
    13: 143
};
let r2 = {
    age: "123",
    name: "dsad",
    city: "shanghai"
};
console.log(r2);
r2.age = '1233';
console.log(r2);
// any 类型 不会进行类型检查 可以设置tsconfig中的 noImplicitAny 为true来禁止隐含的any 类型
let hc = 123;
let hcArr = [123, 2321];
let hcArr1;
// console.log(hc.getxxx()) // 编译不会报错
// unknown 类型 会进行类型检查 可以类似swift as 来转换类型
// 可以任何类型的值赋值给 unknown类型， 需要计算的时候再进行转换
let gsd = "**===";
let kaili = gsd; //不能将类型“unknown”分配给类型“string”。ts(2322)
let shalan = gsd;
console.log(typeof (shalan));
console.log(100 + gsd); // 需要转换好类型 再进行计算
// console.log(str as number) // 不能直接吧string as 成number，需要中间先转一层unknown
console.log(str);
let hc1 = 'dasd';
// void 类型，值为null 或 undefine, 严格模式中只能是undefine
let a = undefined;
console.log(a);
function foo1() {
    // return 'ddd' // 声明void 后不能有返回值,或者返回undefine
    // return void
    console.log("foo1");
    return undefined;
}
foo1();
// never 类型
// never是任何类型的子类型， never类型中没有任何值
// 函数抛出异常或无限循环时返回值是 never
function show() {
    throw new Error('found an error with return value ');
}
let d = '123';
let d2 = 'dsad';
console.log(typeof (d), typeof (d2));
// null 和 undefine 类型
let nullT = null;
let undefineT = undefined;
console.log(nullT, undefineT);
function getName() {
    return null;
}
// let test : string = undefined // 在开启strictNullChecks 后 null、undefined只能赋值给void null undefined
// let test1 : void = undefined
// let test2 : undefined = undefined
// union 联合类型
let uType = 123;
uType = '12345';
console.log(uType);
let uTypeArr = [123, 'dsa', false];
let uTypeArr2 = [1233, true, 'dsadasdsa'];
uTypeArr2.push('charlotte');
console.log(uTypeArr, uTypeArr2);
function dealWith(hc) {
    if (typeof hc === 'boolean') {
        return hc ? "true str" : 'false str';
    }
    else {
        return hc;
    }
}
console.log(dealWith(false));
console.log(dealWith(123));
let sdp1 = {
    ip: '192.168.1.1',
    candidate: ['dsajdklsaj'],
    video: {
        height: 1280,
        width: 720
    },
    audio: {
        codec: 'opus'
    }
};
console.log(sdp1);
// let eInstance :errorCombine = undefined // string & boolean 合并后是never类型
// Pick 类型工具 ， 保留pick出来的类型
let v = { name: 'charlotte' };
let b = { name: 'hc', age: 18 };
let vbInstance = {
    name: 'chaelotte',
    age: 111
};
let vbInstance2 = {
    name: 'chaelotte',
    age: 111
};
console.log(vbInstance, vbInstance2);
let uc1 = 'a';
console.log(typeof uc1); // string
let uc2 = 'a'; //不能把d设置到uc2上去 ，类型只有 a或b
console.log(typeof uc2);
