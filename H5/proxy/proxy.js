let input = document.getElementById('input')
// 设置代理(传入target)
let proxy = new Proxy(input,{
    set (target , p, value, receiver){
        // 设置到result 标签上去
        result.innerText = value;
        return Reflect.set(target,p,value)
    },
    get (target , p , receiver){
        console.log(target , p , receiver)
        return Reflect.get(target,p)
    }
})
// 添加输入监听，然后设置到代理对象中去
input.addEventListener('keyup',(e)=>{
    proxy.textContent = e.target.value;
})