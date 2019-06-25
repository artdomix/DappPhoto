<template>

  <div> 
    <b-container fluid>
       <b-row class="justify-content-md-center text-white"> 
        <h3>
            FAQ
        </h3>
       </b-row>
       <b-row align-h="center">
          <b-col cols="9">
            <div role="tablist">
    <b-card no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button block href="#" v-b-toggle.accordion-1 variant="info">Qu'est ce qu'une dapp?</b-button>
      </b-card-header>
      <b-collapse id="accordion-1" visible accordion="my-accordion" role="tabpanel">
        <b-card-body>
           <b-card-text>{{ reponse1 }}</b-card-text>
        </b-card-body>
      </b-collapse>
    </b-card>

    <b-card no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button block href="#" v-b-toggle.accordion-2 variant="info">Pourquoi cette application existe?</b-button>
      </b-card-header>
      <b-collapse id="accordion-2" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text>{{ reponse2 }}</b-card-text>
        </b-card-body>
      </b-collapse>
    </b-card>

    <b-card no-body class="mb-1">
      <b-card-header header-tag="header" class="p-1" role="tab">
        <b-button block href="#" v-b-toggle.accordion-3 variant="info">Les améliorations à venir</b-button>
      </b-card-header>
      <b-collapse id="accordion-3" accordion="my-accordion" role="tabpanel">
        <b-card-body>
          <b-card-text>{{ reponse3 }}</b-card-text>
        </b-card-body>
      </b-collapse>
    </b-card>
  </div>

          </b-col>
       </b-row>
    </b-container>
  </div>

</template>

<script>
export default {
  name: 'Faq',
  props: {
    msg: String
  },

  data () {
    return {
      name: 'BootstrapVue',
      reponse1: '',
      reponse2: '',
      reponse3: '',
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
