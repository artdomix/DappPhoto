<template>

  <div id="app">
      <div class="cover-container d-flex h-100  mx-auto flex-column">
<Menu/>
<b-container fluid  class="bg-blueNight pt-4 pb-4 pr-0 pl-0" >
  <!-- Content here -->

<router-view></router-view>
      
</b-container>

    <Footer/>  
    </div>

  </div>
</template>

<script>


import Menu from './../components/Menu.vue'
import Footer from './../components/Footer.vue'

/*import Inscription from './../pages/Inscription.vue'
import Import from './../pages/Import.vue'
import Faq from './../pages/Faq.vue'
import Check from './../pages/Check.vue'
import Contact from './../pages/Contact.vue'
import Bibliotheque from './../pages/Bibliotheque.vue'
const router = new VueRouter({
  routes: [
          { path: '', component: Index },
          { path: 'import', component: Import },
          { path: 'faq', component: Faq },
          { path: 'check', component: Check },
          { path: 'contact', component: Contact },
          { path: 'bibliotheque', component: Bibliotheque }
           ]
})*/


export default {
  name: 'app',
  components: {
    Menu,
    Footer
   // Inscription
  }, 
  methods: {
    goBack () {
      window.history.length > 1
        ? this.$router.go(-1)
        : this.$router.push('/')
    }
  }
}

//const app = new Vue({ router }).$mount('#app')
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 40px;
}
.bg-blueNight{
  background-color: #172b4d;
}
</style>
