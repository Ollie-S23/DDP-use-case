import { createRouter, createWebHistory } from 'vue-router'
import Details from '../components/details.vue'
import Entries from '../components/enteries.vue'

const routes = [
  { path: '/', component: Details },
  { path: '/test', component: Entries },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
