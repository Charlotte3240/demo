function interval(delay = 1000, callback) {
  return new Promise((resolve) => {
    let timerId = setInterval(() => {
      callback(timerId, resolve);
    }, delay);
  });
}

interval(100, (timerId, resolve) => {
  // increase div left
  const div = document.querySelector("div");
  let style = window.getComputedStyle(div);
  let left = parseInt(window.getComputedStyle(div).left);
  div.style.left = left + 10 + "px";
  if (left > 200) {
    clearInterval(timerId);
    resolve(div);
  }
})
  // increase div width
  .then((div) => {
    return interval(100, (timerId, resolve) => {
      let width = parseInt(window.getComputedStyle(div).width);
      div.style.width = width + 10 + "px";
      if (width >= 200) {
        clearInterval(timerId);
        resolve(div);
      }
    });
  })
  // increase div height
  .then((div) => {
    return interval(100, (id, resolve) => {
      let height = parseInt(window.getComputedStyle(div).height);
      div.style.height = height + 10 + "px";
      if (height >= 200) {
        clearInterval(id);
        resolve(div);
      }
    });
  })
  // change background color
  .then((div) => (div.style.backgroundColor = "red"));
