// 任务拆分， 把大任务分片
function foo(length, sum) {
  for (let i = 0; i < 1000; i++) {
    if (num <= 0) break;
    sum += num--;
  }
  if (num > 0) {
    setTimeout(foo);
  } else {
    console.log(sum);
  }
}

let num = 987654321;
let sum = 0;
// foo(num,sum);

async function foo2(num) {
  let length = num;
  let result = await Promise.resolve().then((_) => {
    for (let i = 0; i < length; i++) {
      sum += num--;
    }
    return sum;
  });

  console.log(result);
}
foo2(num);
console.log("先执行");
