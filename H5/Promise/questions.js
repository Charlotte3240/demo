setTimeout(() => {
  console.log("1");
}, 0);

Promise.resolve('2').then((value) => console.log(value));

console.log("3");

