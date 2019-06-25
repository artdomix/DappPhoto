<template>
  
<div>
<b-container  fluid>  
  <b-row class="justify-content-md-center text-white">
    <h3>
       Inscription / Connexion
    </h3>
  </b-row>
   
  <b-row class="justify-content-md-center">
    <b-col v-if="appConfig.connected === false">
    
    <b-card class="mt-3" border-variant="dark" header="Inscription à la Dapp">
    <b-form @submit="onSubmit" @reset="onReset" >
      <b-form-group
        id="input-group-1"
        label="Email address:"
        label-for="input-1"
        description="We'll never share your email with anyone else."
      >
        <b-form-input
          id="input-1"
          v-model="form.email"
          type="email"
          required
          placeholder="Enter email"
        ></b-form-input>
      </b-form-group>

      <b-form-group id="input-group-2" label="Your Name:" label-for="input-2">
        <b-form-input
          id="input-2"
          v-model="form.name"
          required
          placeholder="Enter name"
        ></b-form-input>
      </b-form-group>

      <b-form-group id="input-group-3" label="TypePhotographe:" label-for="input-3">
        <b-form-select
          id="input-3"
          v-model="form.TypePhotographe"
          :options="TypePhotographes"
          required
        ></b-form-select>
      </b-form-group>

      <b-button type="submit" variant="primary">S'inscrire</b-button>
      <b-button type="reset" variant="danger">Reset</b-button>
    </b-form>     
  </b-card>
      </b-col>
        <b-col>

     <b-card class="mt-3" border-variant="dark" header="Connexion à la Dapp">
          <hello-metamask ref='helloMetamask' />
          
          <b-button v-on:click="onReset" variant="danger" v-if="appConfig.connected">Déconnection de l'application</b-button>
     </b-card>
        </b-col>
    
  </b-row>

</b-container> 
</div>

</template>

<script>

const ethers = require('ethers');
import HelloMetamask from '@/components/HelloMetamask'

import {mapGetters, mapActions} from 'vuex'
export default {
  name: 'inscription',
  props: {
    msg: String
  },
  components: {
        'hello-metamask': HelloMetamask
  },
  data () {
    return {
      show: true,
      showDeconnection: false,
      form: {
          email: '',
          name: '', //name du wallet metamask
          TypePhotographe: 0
        },
        TypePhotographes: [{value: 0, text: 'Independant'}, 
                           {value: 1, text: 'Collaboration'},
                           {value: 2, text: 'Agence'},
                           {value: 3, text: 'Modele'},
                           {value: 4, text: 'Client'}]
    }
  },
  watch: {
     
  },
  computed: {
    ...mapGetters(['appConfig', 'dataContract'])
  },
  mounted () { 
    //this.appConfig = this.$store.getters['appConfig']
    //console.log('appConfig', this.$store.getters['appConfig'])
  },
  methods: {
    ... mapActions(['updateAppConfig']),
    toggle () {
 
    },
     onSubmit: async function(){
        
        this.show = false
        this.showDeconnection = true
        this.addresses = await ethereum.enable()
        this.provider = await new ethers.providers.Web3Provider(ethereum)
     

      let appConfig = { 
        nom: this.addresses[0],
        provider: await new ethers.providers.Web3Provider(ethereum),
        adresses: [],
        network:"",
        connected: false,
        //contractData:dataContract,
        contrat:{},
        signer: await this.provider.getSigner(this.addresses[0])
      }
      this.updateAppConfig(appConfig)
               
          try{
                  //Connect to contrat

                  let contratAddress = this.dataContract.address.toLowerCase();
                  let contratAbi = await this.dataContract.abi
                  let contract = await new ethers.Contract(contratAddress, contratAbi, this.appConfig.provider);
                  console.log(this.appConfig.provider.getSigner(this.appConfig.nom));
                  console.log("adresse contract: "+contratAddress);
                  console.log("address: "+ this.appConfig.nom);
                  let contractSigner =  contract.connect(this.appConfig.signer);
                  const tx = await contractSigner.inscriptionPhotographe(this.form.name,
                                                                          this.form.email,
                                                                          this.form.TypePhotographe );
                                    
                    tx.wait().then((result) =>
                      {
                        console.log('result:', result);                        
                        alert("Vous êtes inscrit sur l'application. " )  
                        this.$refs.helloMetamask.connectMetamask()                        
                      }
                    );
                  
                   
                
              }catch(err){
                console.log(err);      
                alert("Vous n'êtes pas inscrit sur l'application. " )
              }
      },
      onReset(evt) {
        evt.preventDefault()
        // Reset our form values
        this.form.email = ''
        this.form.name = ''
        this.form.TypePhotographe = null
        this.form.checked = []
        // Trick to reset/clear native browser form validation state
        this.show = false

        let appConfig = { 
          nom: 'inconnu',
          provider: {},
          adresses: [],
          network:"",
          connected: false,
          contrat:{},
          signer: {}
        }        
        this.$refs.helloMetamask.updateAppConfig(appConfig)
        this.showDeconnection = false
        this.$nextTick(() => {
          this.show = true
        })
      }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
