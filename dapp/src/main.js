import Vue from 'vue'
import VueRouter from 'vue-router'
import store from './store'

import BootstrapVue from 'bootstrap-vue'
import QrImage from 'qr-image'
const Exif = require('exif-js');
const ethers = require('ethers');

Vue.config.productionTip = false
Vue.use(VueRouter)
Vue.use(BootstrapVue)
Vue.use(QrImage)
Vue.use(Exif)
Vue.use(ethers)
//Vue.use(Breadcrumb)

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import 'bootstrap/dist/css/bootstrap.css'


// 2. Define some routes
// Each route should map to a component. The "component" can
// either be an actual component constructor created via
// `Vue.extend()`, or just a component options object.
// We'll talk about nested routes later.
//import Menu from './components/Menu.vue'
import Layout from './layouts/Layout.vue'
import Index from './pages/Index.vue'
import Inscription from './pages/Inscription.vue'
import Import from './pages/Import.vue'
import Faq from './pages/Faq.vue'
import Check from './pages/Check.vue'
import Contact from './pages/Contact.vue'
import Bibliotheque from './pages/Bibliotheque.vue' 
//import { NONCE_EXPIRED } from 'ethers/errors';

//const VueLoaderPlugin = require('vue-loader/lib/plugin')
const router = new VueRouter({
  routes: [
    // UserHome will be rendered inside User's <router-view>
    // when /user/:id is matched
    { path: '/', component: Index },
    { path: '/inscription', component: Inscription },
    { path: '/import', component: Import, meta: { requireAuth: true }},
    { path: '/faq', component: Faq },
    { path: '/check', component: Check, meta: { requireAuth: true }},
    { path: '/contact', component: Contact },
    { path: '/bibliotheque', component: Bibliotheque, meta: { requireAuth: true }}

  ]
})

router.beforeEach((to, from, next) => {
  if (!store.getters.appConfig.connected && to.meta && to.meta.requireAuth){
    next(false)
  }else{
    next()
  }
}
)


// 3. Create the router instance and pass the `routes` option
// You can pass in additional options here, but let's
// keep it simple for now.

new Vue({
  render: h => h(Layout),
  store,
  router
}).$mount('#app')

Vue.config.errorHandler = (err) => {
	alert(err.message)
}

