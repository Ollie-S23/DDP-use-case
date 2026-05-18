import { createRouter, createWebHistory } from 'vue-router'
import Details from '../components/details.vue'

const routes = [
  { path: '/', component: Details },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
