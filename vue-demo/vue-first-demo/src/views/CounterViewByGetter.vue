<script setup>
import { useCounterStore } from '@/stores/counterByGetter'

const store = useCounterStore()

setInterval(() => {
  store.update()
}, 1000)
</script>

<template>
  <div class="counter1">
    <h1>click to count</h1>
    <button @click="store.increment">Count: {{ store.count }}</button>
    <p>Double Count: {{ store.doubleCountValue }}</p>
    <p>Click Count: {{ store.clickCount }}</p>
    <p>Time: {{ store.time }}</p>
  </div>
</template>
