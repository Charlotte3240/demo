class HC {
  static PENDING = "pending";
  static FULFILLED = "fulfilled";
  static REJECTED = "rejected";

  constructor(executor) {
    this.status = HC.PENDING;
    this.value = null;

    // 暂时存放未执行的函数
    this.callbacks = [];

    try {
      executor(this.resolve.bind(this), this.reject.bind(this));
    } catch (error) {
      this.reject(error);
    }
  }

  resolve(value) {
    if (this.status == HC.PENDING) {
      this.status = HC.FULFILLED;
      this.value = value;
      setTimeout(() => {
        this.callbacks.map((item) => {
          item.onFulfilled(value);
        });
      });
    }
  }

  reject(reason) {
    if (this.status == HC.PENDING) {
      this.status = HC.REJECTED;
      this.value = reason;
      setTimeout(() => {
        this.callbacks.map((item) => {
          item.onRejected(reason);
        });
      });
    }
  }

  then(onFulfilled, onRejected) {
    if (typeof onFulfilled != "function") {
      onFulfilled = () => this.value;
    }
    if (typeof onRejected != "function") {
      onRejected = () => this.value;
    }

    let promise = new HC((resolve, reject) => {
      // 如果是异步改变的promise状态
      // 这里的状态还是pending 不会执行下面的代码
      if (this.status == HC.PENDING) {
        setTimeout(() => {
          this.callbacks.push({
            onFulfilled: (value) => {
              this.parse(promise, onFulfilled(value), resolve, reject);
            },
            onRejected: (reason) => {
              this.parse(promise, onRejected(reason), resolve, reject);
            },
          });
        });
      }

      if (this.status == HC.FULFILLED) {
        setTimeout(() => {
          this.parse(promise, onFulfilled(this.value), resolve, reject);
        });
      }
      if (this.status == HC.REJECTED) {
        setTimeout(() => {
          this.parse(promise, onRejected(this.value), resolve, reject);
        });
      }
    });
    return promise;
  }

  parse(promise, result, resolve, reject) {
    if (promise == result) {
      throw new TypeError("Chaining cycle detected");
    }
    try {
      // 判断是否为promise（HC）对象 否则就是直接传值
      if (result instanceof HC) {
        result.then(resolve, reject);
      } else {
        resolve(result);
      }
    } catch (error) {
      reject(error);
    }
  }

  static resolve(value) {
    return new HC((resolve, reject) => {
      if (value instanceof HC) {
        value.then(resolve, reject);
      } else {
        resolve(value);
      }
    });
  }
  static reject(value) {
    return new HC((resolve, reject) => {
      if (value instanceof HC) {
        value.then(resolve, reject);
      } else {
        reject(value);
      }
    });
  }

  static all(promises) {
    /*
     * all 返回的也是一个promise
     */
    return new HC((resolve, reject) => {
      let result = [];
      promises.forEach((promise) => {
        promise.then(
          (value) => {
            result.push(value);
            if (result.length == promises.length) {
              resolve(result);
            }
          },
          (reason) => {
            reject(reason);
          }
        );
      });
    });
  }

  static race(promises) {
    return new HC((resolve, reject) => {
      promises.map(promise => {
        promise.then(
          (value) => {
            resolve(value);
          },
          (reason) => {
            reject(reason);
          }
        );
      });
    });
  }
}

let h1 = HC.resolve("h1");

let h2 = HC.resolve("h2");

let h3 = HC.reject("h3");

HC.race([h1, h2, h3]).then(
  (v) => {
    console.log(v);
  },
  (reason) => {
    console.log(reason);
  }
);

// Promise.resolve("n")
//   .then((v) => {
//       console.log(v);
//     return v;
//   })
//   .then((v) => console.log(v));
