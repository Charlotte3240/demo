"use strict";
///<reference path="generics.ts"/>
var Users;
(function (Users) {
    Users.name = `charlotte`;
    let Vip;
    (function (Vip) {
        Vip.level = 1;
    })(Vip = Users.Vip || (Users.Vip = {}));
})(Users || (Users = {}));
var Member;
(function (Member) {
    let name = `nsqk.com`;
})(Member || (Member = {}));
console.log(Users.name);
// console.log(Member.name) // 没有导出会报错
console.log(Users.Vip.level);
// 合并打包ts 文件
/*
*  `tsc --outFile ./dits/app.js a.ts b.ts`
* */
/*
* 或者通过reference 引入 ，这样只需要编译一个ts就可以
* webstorm中 缩写为 ref
* ///<reference path="generics.ts"/>
* */
// 使用amd模块进行打包
//Asynchronous Module Definition
