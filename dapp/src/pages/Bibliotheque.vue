<template>
<div>

<b-container fluid >
   
  <b-row class="justify-content-md-center text-white">
       <h3>
          Bibliotheque
       </h3> 
       <img v-on:click="GetAllPhoto()" src="../assets/img/refresh.png" class=" refresh d-inline-block align-top" alt="refresh">
         
  </b-row>
  
  <b-row v-if="bibliothequeEnable" class="p-4 bg-dark justify-content-md-center text-white" >
    <h4> Les images stockés dans la blockchain</h4>
  </b-row>
  <b-row v-if="bibliothequeEnable" class="p-4 bg-dark" >
      <b-col cols="3" ref="galerie" v-for="photo in photos" :key="photo[4]">
        <b-img-lazy  thumbnail  v-bind="mainProps" :src="getImageUrl( photo[0] )" :alt="photo[1]" 
        v-b-popover.hover="'Titre: ' +photo[2]" :title="'Photographe: '+ photo[1]"></b-img-lazy> 
      </b-col>
  </b-row>
  <b-row class="p-4 bg-dark" v-else >
    <b-col>
      <b-img thumbnail fluid src="https://picsum.photos/250/250/?image=54" alt="Image 1"></b-img>
    </b-col>
    <b-col>
      <b-img thumbnail fluid src="https://picsum.photos/250/250/?image=58" alt="Image 2"></b-img>
    </b-col>
    <b-col>
      <b-img thumbnail fluid src="https://picsum.photos/250/250/?image=59" alt="Image 3"></b-img>
    </b-col>    
  </b-row>

</b-container>
</div>
</template>

<script>
import {mapGetters} from 'vuex'
const ethers = require('ethers');
export default {
  name: 'Bibliotheque',
  props: {
    msg: String
  },

  data () {
    return {
      //0x5ab90c000291e662023366fb1d93bbd2f04aaf42cc62311eed32112a6b038e81
      //0x81acc8cdec7166addc99f5cf7f871a34183e0ed4b5307a3f4ae1aab03316f9ee
      name: 'BootstrapVue',
      show: true,
      bibliothequeEnable: false,
      photos: [],
      mainProps: {
          center: true,
          blank: true,
          blankColor: '#bbb',
          width: 400,
          height: 200,
          class: 'm-5'
        }
    }
  }, 
  computed: {
    ...mapGetters(['appConfig', 'dataContract'])
  },
  watch: {

  },
  methods: {
    toggle () {
 
    },
    getImageUrl(imageHashIpfs) {
              return `https://ipfs.io/ipfs/${imageHashIpfs}`
      },
    GetAllPhoto: async function(){
      this.bibliothequeEnable = true;
        try{
                  let contratAddress = this.dataContract.address.toLowerCase();
                  let contratAbi = this.dataContract.abi
                  let contract = new ethers.Contract(contratAddress, contratAbi, this.appConfig.provider);
                  let contractSigner = contract.connect(this.appConfig.signer);
                  const tx = await contractSigner.id_photo() ;
                 console.log('tx:',tx.toNumber());
                 
                 for (let index = 0; index < tx.toNumber(); index++) {
                    let _photoHash = await contractSigner.photos(index);
                    // const _photoHash = tx[index];
                    console.log('photohash: ',_photoHash);
                    let result= await contractSigner.getImage(_photoHash)
                    console.log('result',result);
                    
                    this.photos.push ([result[5], result[1], result[0]]);
                      //var b = '<b-img-lazy v-bind="mainProps" :src="'+this.getImageUrl(_photoHash)+'" alt="Image 1"></b-img-lazy>'
                    
                  }
        } catch(err){
                console.log(err);
                //alert(JSON.stringify(err));
        } 
    }         
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.refresh{
    width: 50px;
    float: left;
}
</style>
