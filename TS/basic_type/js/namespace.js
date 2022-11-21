"use strict";
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
