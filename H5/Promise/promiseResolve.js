// promise resolve 做缓存
Promise.resolve("resolve value").then((value) => {
  console.log(value);
});

Promise.resolve("value")
  .then((value) => {
    console.log("1" + value);
    if (value == "value") {
      return Promise.resolve(value);
    } else {
      return Promise.reject("error");
    }
  })
  .then((value) => {
    console.log("2");
  })
  .then((value) => {
    console.log("3");
  })
  .catch((error) => {
    console.log(error);
  });
