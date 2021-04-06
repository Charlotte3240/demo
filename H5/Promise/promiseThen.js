new Promise((resolve, reject) => {
  //   resolve("value string");
  // reject('reason string value')
}).then(
  (value) => {
    console.log(value);
  },
  (reason) => {
    console.log(reason);
  }
);

let p1 = new Promise((resolve, reject) => {
  resolve("fulfilled");
});

let p2 = p1.then(
  (value) => console.log(value),
  (reason) => console.log(reason)
);

setTimeout(() => {
  console.log(p1);
  console.log(p2);
});
