class HCError extends Error {
  constructor(parma) {
    super(parma);
    this.name = "HCError";
    // this.message = "HCError message";
  }
}

class HCHttpError extends Error {
  constructor(parma) {
    super(parma);
    this.name = "HCHttpError";
    // this.message = "HCHttpError message";
  }
}

function req(url) {
  return new Promise((resolve, reject) => {
    // 检查URL 格式
    if (!/^http/.test(url)) {
      throw new HCError("请求参数错误");
    }

    let xhr = new XMLHttpRequest();
    xhr.open("GET", url);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.send();
    xhr.onload = () => {
      if (this.status == 200) {
        resolve(JSON.parse(this.response));
      } else if (this.status == 404) {
          // throw 适用于 同步抛出 异步用reject
        //   throw new HCHttpError('http请求错误')
        reject(new HCHttpError('http请求错误'))
      } else {
        reject("失败处理");
      }
    };

    xhr.onerror = () => {
    //   reject(this);
    reject(new HCHttpError('http请求错误'))

    };
  });
}

req("http://localhost:8888")
  .then(
    //先获取 第一个任务返回值
    (res) => console.log(res)
  )
  .then(
    // 处理 上面的then返回的promise
    (res) => console.log(res)
  )
  .catch((err) => {
    console.log(err);
  })
  .finally(() => {
      // 相当于 rx 中的 complete 
    console.log('finally');
  })
