function queue(numbers) {
  let promise = Promise.resolve();
  numbers.map((item) => {
    promise = promise.then((_) => {
      // 第二次传入的item 是方法
      return item();
    });
  });
}

function p1() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("p1");
      resolve();
    }, 1000);
  });
}

function p2() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("p2");
      resolve();
    }, 2000);
  });
}
// 利用数组和map遍历 来创建一个队列
// queue([1, 2, 3, 4, 5]);

// p1 p2 为promise 类型
// queue([p1, p2,p1,p2]);

function q1() {
  return new Promise((resolve, reject) => {
    console.log("p1");
    resolve();
  });
}

function q2() {
  return new Promise((resolve, reject) => {
    console.log("p2");
    resolve();
  });
}

// 通过reduce 来创建队列
function queue2(promises) {
  // 这里的pre 是promise,初始值传入一个 Promise.resolve()，所以pre的then就可以被调用
  promises.reduce((pre, cur) => {
    return pre.then(() => {
      return new Promise((resolve) => {
        setTimeout(() => {
          resolve();
          console.log(cur);
        }, 1000);
      });
    });
  }, Promise.resolve());
}
queue2([p1, p2, p1, p2]);

function queueByReduce(numbers) {
  numbers.reduce((promise, n) => {
    return promise.then(() => {
      return new Promise((resolve) => {
        console.log(n);
        setTimeout(() => {
          resolve();
        }, 1000);
      });
    });
  }, Promise.resolve());
}
// queueByReduce([1, 2, 3, 4, 5]);

let array = [1, 2, 3, 4, 5, 1, 32, 3, 34, 1111, 1, 1, 1, 1, 3, 3, 3, 33, 3];

// 把previous 当成了计数的变量
function arrayItemCount(arr, specialItem) {
  return arr.reduce((pre, cur) => {
    pre += specialItem == cur ? 1 : 0;
    return pre;
  }, 0);
}
// 寻找数组里面为3的元素个数
console.log(arrayItemCount(array, 3));

// 找到数组里面的最大值
function findMaxWithArray(array) {
  return array.reduce((pre, cur) => {
    return pre > cur ? pre : cur;
  }, 0);
}

console.log(findMaxWithArray(array));
