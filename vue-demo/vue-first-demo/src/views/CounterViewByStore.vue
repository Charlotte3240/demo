<template>
  <div class="counter2">
    <h1>click to count</h1>
    <button @click="increment">Count: {{ counter }}</button>
    <p>Double Count: {{ doubleCount }}</p>
    <p>Click Count: {{ counter }}</p>
    <p>Time: {{ time }}</p>

    <input @keyup.alt.enter="clear" />
    <br />

    <div @click.alt.exact="doSomething">Do something</div>
    <br />

    <button @click.r.right="onClick">mouse right click</button> -->
    <div><textarea v-model="message" placeholder="add multiple lines"></textarea></div>

    <div>
      <label
        >input message
        <p style="white-space: pre-line">{{ message }}</p></label
      >
    </div>

    <input type="checkbox" id="checkbox" v-model="checked" @change="handleCheckboxChange" />
    <label for="checkbox">{{ checked }}</label>
  </div>
</template>

<script setup>
import { storeToRefs } from 'pinia'
import { useCounterStoreRef } from '@/stores/counterByStore' // 引入你定义的 Pinia Store
import { ref } from 'vue'
// 获取 Pinia 的 store 实例
const store = useCounterStoreRef()
const { count: counter, doubleCount, time } = storeToRefs(store)
const { increment, update } = store

const message = ref('input message')
const checked = ref(false)

setInterval(() => {
  update()
}, 1000)

function doSomething() {
  console.log(`click do something`)
}

function clear() {
  console.log(`trigger clear`)
}

function onClick() {
  console.log(`right click`)
}

function handleCheckboxChange() {
  // 可以在这里添加其他逻辑，避免 v-model 更新时的延迟
  console.log('Checkbox changed')
}
</script>
