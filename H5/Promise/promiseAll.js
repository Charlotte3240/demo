
let p1 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("complete1");
    // reject("error 1");
  }, 1000);
});

let p2 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve("complete2");
  }, 100);
});

function queryData(url, timeout = 2000) {
  // 利用 race 做一个超时限制
  let normalP = new Promise((resolve, reject) => {
    return req(url)

    // setTimeout(() => {
    //   resolve("请求返回");
    // }, 3000);
  });

  let timeoutP = new Promise((resolve, reject) => {
    setTimeout(() => {
      reject("超时返回");
    }, 2000);
  });

  return Promise.race([normalP, timeoutP])
    .then((value) => {
      console.log(value);
    })
    .catch((error) => console.log(error));
}


queryData(`http:liu-mbp.local:8888`,1000).then(() => {

})



// Promise.race([p1, p2])
//   .then((result) => {
//     console.log(result);
//   })
//   .catch((error) => console.log(error));

// Promise.allSettled([p1, p2]).then((result) => {
//   // 过滤 reject 或者 pendding 状态
//   result = result.filter((item) => {
//     return item.status == "rejected" ? false : true;
//   });

//   result.forEach((item) => {
//     console.log(item);
//   });
// });

// Promise.all([p1, p2])
//   .then((result) => {
//     console.log("promise all");
//     console.log(result);
//     result.forEach((item) => {
//       console.log(item);
//     });
//   })
//   .catch((error) => {
//     console.log(error);
//   });
