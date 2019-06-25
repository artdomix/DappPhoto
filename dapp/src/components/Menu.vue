<template>
  <div class="hello">
      <header class="masthead mb-auto">
        <div class="inner">  
          
                
         <b-navbar-brand href="#">
            <img src="../assets/img/logo.png" class=" logo d-inline-block align-top" alt="Kitten">
            <h3 align-v="center" class="masthead-brand"  style="padding-top: 33px;">Dapp Photo</h3>
         </b-navbar-brand>
          <b-navbar class="justify-content-md-center" toggleable="lg" type="dark" variant="dark"> 
            <b-nav >
                <b-nav-item active><router-link to="/">Home</router-link></b-nav-item>
                <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
                <b-nav-item ><router-link to="inscription">Inscription</router-link></b-nav-item>
                <b-nav-item ><router-link to="import">Import d'images</router-link></b-nav-item>
                <b-nav-item ><router-link to="check">Vérifier une image</router-link></b-nav-item>
                <b-nav-item ><router-link to="bibliotheque">Bibliothèque</router-link></b-nav-item>
                <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
                <b-nav-item ><router-link to="contact">Contact</router-link></b-nav-item>
                <b-nav-item ><router-link to="faq">Pourquoi la blockchain</router-link></b-nav-item>                
            </b-nav>
          </b-navbar>
        </div>
      </header>
    
  </div>
</template>

<script>
export default {
  name: 'Menucontent',
  props: {
    msg: String
  },

 /* data () {
    return {
      name: 'BootstrapVue',
      show: true
    }
  },
  watch: {
    show (newVal, oldVal) {
      
    }
  },*/
  methods: {
    toggle () {
     
    },
    dismissed () {
      
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.logo{
    width: 90px;
    float: left;
}
</style>
