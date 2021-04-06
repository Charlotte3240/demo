/*
    以往  Promise 都是 .catch 或者 .reason 来处理
    现在使用async 和 await 后 可以直接按照同步的代码来处理错误
    或者按照以往的形式 .catch 同样也可以接收到错误
    使用 try catch
*/

async function hc() {
  try {
    let json = await req("http://liu-mbp:8888");
    return json;
  } catch (error) {
    alert(error)
  }
}

hc();

// try {
//   hc();
// } catch (err) {
//   console.log("catch error");
//   console.log(err);
// }

// hc().catch((error) => console.log(error));
