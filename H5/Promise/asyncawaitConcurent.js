let p1 = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("p1");
    }, 1000);
  });
};

let p2 = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve("p2");
    }, 1000);
  });
};

async function concurrentExcute() {
  //   let r1 = p1();
  //   let r2 = p2();

  //   let v1 = await r1;
  //   let v2 = await r2;
  //   console.log(`complete ${v1} ${v2}`);

  let result = await Promise.all([p1(), p2()]);
  console.log(result);
}

concurrentExcute();
