"use strict";
function foo(arg) {
    return arg;
}
function foo1(arg) {
    return arg;
}
console.log(typeof foo1('asd'));
console.log(typeof foo1(123));
console.log(typeof foo1(false));
console.log(foo1('charlotte'));
// 类型继承
function getLength(arg) {
    return arg.length; //  any没有这个属性
}
function getMax(args) {
    let max = 0;
    args.forEach((e) => {
        if (e > max) {
            max = e;
        }
    });
    return max;
}
console.log(getMax([1, 3, 4, 5, 6]));
// 更改为含有length属性的类型都可以使用
function getLengthFull(arg) {
    return arg.length;
}
console.log(getLengthFull("first"));
