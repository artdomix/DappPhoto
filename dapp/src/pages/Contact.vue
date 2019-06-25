<template>

  <div> 
    <b-container fluid>
       <b-row class="justify-content-md-center text-white"> 
        <h3>
            Contactez-moi
        </h3>
      </b-row>
 <b-row class="mb-2 justify-content-md-center">     
<b-card
    title="Dominique Nitoumbi"
    img-src="https://chancel.art-domix.fr/img/photos/autres/AP3A5363.jpg"
    img-alt="Image"
    img-top
    tag="article"
    style="max-width: 20rem;"
    class="mb-2 justify-content-md-center"
  >
    <b-card-text>
     Développeur Blockchain <br />ayant suivie la formation Alyra </b-card-text>

    <b-button class="mr-1" variant="outline-success">
      <b-link  href="https://www.linkedin.com/in/dominique-nitoumbi-a74b4035/" >Linkedin</b-link>
    </b-button> 
    <b-button variant="outline-success">
      <b-link href="https://github.com/artdomix" >Github</b-link>
    </b-button>
    
  </b-card>
 </b-row>

</b-container>

</div>
  


</template>

<script>
export default {
  name: 'Contact',
  props: {
    msg: String
  },

  data () {
    return {
      name: 'BootstrapVue',
      show: true
    }
  },
  watch: {

  },
  methods: {
    toggle () {
 
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
