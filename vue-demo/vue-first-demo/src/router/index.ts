import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import CounterViewByGetter from '../views/CounterViewByGetter.vue'
import CounterViewByStore from '../views/CounterViewByStore.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },

    {
      path: '/counter1',
      name: 'counter1',
      component: CounterViewByGetter
    },
    {
      path: '/counter2',
      name: 'counter2',
      component: CounterViewByStore
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue')
    }
  ]
})

export default router
