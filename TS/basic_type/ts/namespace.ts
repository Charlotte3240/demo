///<reference path="generics.ts"/>



namespace Users{
    export let name = `charlotte`
    export namespace Vip{
        export let level = 1
    }
}

namespace Member{
    let name = `nsqk.com`
}

console.log(Users.name)
// console.log(Member.name) // 没有导出会报错
console.log(Users.Vip.level)


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