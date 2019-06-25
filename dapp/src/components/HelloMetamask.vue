<template>
  <div id="metamask">
      <p>Hello</p>    
      <h5>Bienvenue {{ appConfig.nom }}</h5>      
      <b-button v-if="appConfig.connected === false" v-on:click="connectMetamask()" variant="primary" >Connexion à l'application</b-button> 
  </div>
</template>

<script>

const ethers = require('ethers');
import {mapGetters, mapActions} from 'vuex'

export default {
 name: 'hello-metamask',
  //el: 'metamask',
  data () {
    return {};
    
  },
  computed: {
    ...mapGetters([ 'appConfig','dataContract'])
  },
  mounted () {
    //console.log('appConfig', this.$store.getters)
  },
  beforeCreate: function () {      
          //this.contractData=contractData;        
  },
  methods:{
    ... mapActions(['updateAppConfig']),
    connectMetamask: async function() {
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
      this.getNetwork()
      this.getContract()
    },
    getNetwork: async function() {
      this.appConfig.network = await this.appConfig.provider.getNetwork()  
      // eslint-disable-next-line
      console.log("Network: ", this.appConfig.network) 
      // eslint-disable-next-line
      console.log("contractData",this.dataContract)
      // eslint-disable-next-line
      console.log("Provider",this.appConfig.provider)      
      this.updateAppConfig(this.appConfig)
    },
    getContract: async function() {
       try{
              //Connect to contrat
            let contratAddress = this.dataContract.address.toLowerCase();
            let contratAbi = await this.dataContract.abi
            let contract = await new ethers.Contract(contratAddress, contratAbi, this.appConfig.provider);
            
            let contractSigner =  contract.connect(this.appConfig.signer);
            const tx = await contractSigner.connexion(this.appConfig.nom);
            console.log('tx: ',tx);
            if (tx[0] == false) {
              let appConfig = { 
                nom: tx[1],
                provider: {},
                adresses: [],
                network:"",
                connected: false,
                contrat:{},
                signer: {}
              }
              this.updateAppConfig(appConfig)
              alert("Vous n'êtes pas connecté à l'application.")  
               
            } else{
              this.appConfig.nom = tx[1]
              this.appConfig.connected = true
              this.updateAppConfig(this.appConfig)
              alert("Vous êtes connecté à l'application.") 
            }            
          
        }catch(err){
          console.log('Error: ',err);
          //alert(JSON.stringify(err));
        }     
    }
    

  }

}
</script>

<style scoped>

</style>