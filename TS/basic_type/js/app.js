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
    var max = 0;
    args.forEach(function (e) {
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
var Collection = /** @class */ (function () {
    function Collection() {
        this.data = [];
    }
    Collection.prototype.push = function () {
        var _a;
        var items = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            items[_i] = arguments[_i];
        }
        (_a = this.data).push.apply(_a, items);
    };
    Collection.prototype.shift = function () {
        return this.data.shift();
    };
    return Collection;
}());
///<reference path="generics.ts"/>
var Users;
(function (Users) {
    Users.name = "charlotte";
    var Vip;
    (function (Vip) {
        Vip.level = 1;
    })(Vip = Users.Vip || (Users.Vip = {}));
})(Users || (Users = {}));
var Member;
(function (Member) {
    var name = "nsqk.com";
})(Member || (Member = {}));
console.log(Users.name);
// console.log(Member.name) // 没有导出会报错
console.log(Users.Vip.level);
// 合并打包ts 文件
/*
*  `tsc --outFile ./dits/app.js a.ts b.ts`
* */ 
