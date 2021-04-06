// 同步任务 -> 微任务队列 -> 宏任务队列(settimeout等等)
setTimeout(() => {
    console.log('宏任务')
}, 0);

new Promise((resolve,reject) => {
    resolve()
    console.log('同步任务');
})
.then(value => {
    console.log('promise 微任务');
    setTimeout(() => {
        console.log('宏任务2')
    }, 0);
})




// 准备阶段
let p = new Promise((resolve, reject) => {
  // 成功回调
  resolve("成功状态");
  // 失败回调
  // reject('失败状态')
});
p.then(
  (value) => {
    console.log("then complete");

    /*
        中断then的调用
    */
    // 返回 reject状态  即 失败状态
    // return (new Promise((resolve,reject)=>{reject()}))
    // 返回pending状态  即 准备阶段
    return new Promise(() => {});
  },
  // 对单个then进行错误处理，这里需要 加入终止后续then 执行的代码
//   (reason) => {
//     console.log("catch error ");
//   }
)
  .then((value) => {
    console.log("then repeat");
  })
  .then((value) => {
    console.log("then repeat1");
  });

p.catch(() => {
  console.log("catched error ");
});



