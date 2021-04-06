
// 简单异步加载图片
function loadImage(src, resolve, reject) {
  let image = new Image();
  image.src = src;
  image.onload = () => {
      image.width = 200;
      resolve(image)
  };
  image.onerror = reject;
}

// loadImage(
//   "https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/56e43314b42a4bf9abf69daca390895d~tplv-k3u1fbpfcp-zoom-1.image",
//   (res) => {
//     console.log("load success");
//     document.body.appendChild(res)
//   },
//   () => {
//     console.log("load failure");
//   }
// );

console.log('start load image')


//定时器轮询
function interval(callback,delay) {
    let id  = setInterval(() => callback(id), delay);
}

interval((intervalId) => {

    const div = document.querySelector('div')
    let style = window.getComputedStyle(div)
    console.log(style.left)
    let left = parseInt(window.getComputedStyle(div).left)
    if (left > 200){//document.documentElement.clientWidth
        // left = 1 
        console.log('clear interval')
        clearInterval(intervalId)

        //当达成一定条件后
        interval((intervalId) => {
            // change width
            let width = parseInt(window.getComputedStyle(div).width)
            if (width >= 400){
                clearInterval(intervalId)
                console.log('interval  log')
            }
            div.style.width = width + 10 + 'px'
            console.log('change width ' + width)
        },10)
    }
    div.style.left = left+10+'px'

},10)

console.log('interval  log')