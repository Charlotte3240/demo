import { ref, computed, shallowRef, nextTick } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStoreRef = defineStore('counter1', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  const time = ref(new Date())
  async function increment() {
    count.value++
    // await nextTick() // 等待下次 runloop 刷新 dom
    console.log('increment')
  }
  function update() {
    time.value = new Date()
  }
  // shallowRef // 不追踪深层的变化， 比如 map 中的东西

  return { count, doubleCount, time, increment, update }
})
