import { ref, computed, shallowRef, nextTick } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter2', {
  state: () => ({
    count: 10,
    clickCount: 0,
    time: new Date()
  }),
  getters: {
    countValue: (state) => state.count,
    doubleCountValue: (state) => state.count * 2
  },
  actions: {
    increment() {
      console.log('increamented')
      this.count++
      this.clickCount++
    },
    update() {
      this.time = new Date()
    }
  }
})
