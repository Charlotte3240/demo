// 语法糖
async function hc() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("timeout");
    }, 1000);
  });
}
// async 方法 是一个 fulfilled 状态的 promise
// console.log(hc());

hc().then((v) => {
  //   console.log(v);
});

async function hc2() {
  let name = await new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("获取到姓名");
    }, 1000);
  });
  console.log("name :" + name);

  let score = await new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("获取到分数");
    }, 2000);
  });

  console.log("score :" + score);
}
// hc2();

// async function sleep(delay) {
//   let value = await new Promise((resolve, reject) => {
//     setTimeout(() => {
//       console.log("time down");
//       resolve("sleep return ");
//     }, delay);
//   });

//   console.log("value " + value);
// }
// sleep(4000);

async function hcSleep(delay = 2) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, delay * 1000);
  });
}

async function showData() {
  for (const item of ["one", "two", "other"]) {
    await hcSleep();
    console.log(item);
  }
}

// showData();

async function hcdelay() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("delay value");
    }, 2000);
  });
}

const fool = async () => {
  let value = await hcdelay();
  console.log("fool " + value);
};
// fool();

class HC {
  constructor(name) {
    this.name = name;
  }
  then(resolve, reject) {
    setTimeout(() => {
      console.log("ues constructor name " + this.name);
      resolve(this.name);
    }, 2000);
  }
}

async function getSomeData() {
  let user = await new HC("this name");
  console.log("创建用户 user" + user);
}
getSomeData();
