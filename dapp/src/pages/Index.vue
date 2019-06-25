<template>
<div>
<b-container fluid>   
  <b-row>
    <b-carousel
    id="carousel-fade"
    style="text-shadow: 0px 0px 2px #000"
    fade
    indicators
    img-width="100%"
    img-height="480px"
  >
    <b-carousel-slide
      caption="Dapp Photo"
      text="Vérification de l'authenticité de la photo"
      img-src="https://chancel.art-domix.fr/img/photos/2/59ff7323d99d84c4bf418f95315735cd.jpeg"
    ></b-carousel-slide>
    <b-carousel-slide
    
      caption="Confiance"
      text="Vous n'aurez plus besoin de douter."
      img-src="https://chancel.art-domix.fr/img/photos/2/0d1b4fc94a3ae18a9d972b26584e5b80.jpeg"
    ></b-carousel-slide>
    <b-carousel-slide
      caption="Valeur"
      text="Fait par un photographe pour les photographes."
      img-src="https://chancel.art-domix.fr/img/photos/2/c7cfa264ce7b843c733a9e198e968b15.jpeg"
    ></b-carousel-slide>
  </b-carousel>

  </b-row>
    <b-row v-show="false">
    <b-col lg="4" class="pb-2">
      <b-button   v-on:click="testnodeExif()" size="lg" variant="primary">
     comm
      </b-button>
  <img id="img1" width="300" src="../assets/cosplayrouge.jpg"/>
    </b-col>
  </b-row>
  <b-row v-show="false">
    <b-col lg="4" class="pb-2">
      <b-button   v-on:click="testExif()" size="lg" variant="primary">
     comm
      </b-button>
  <img id="img1" width="300" src="../assets/cosplayrouge.jpg"/>
    </b-col>
  </b-row>
 </b-container> 
</div>
</template>

<script>
const Exif = require('exif-js');
const NodeExif = require('node-exiftool');
const exiftoolBin = require('dist-exiftool')
export default {
  name: 'Index',
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
    testExif(){
    Exif.getData(document.getElementById("img1"), function() {
                var allMetaData = Exif.getAllTags(this);
                
                var make = Exif.getTag(this, "Makedede");
                var model = Exif.getTag(this, "Copyright");

                let DateTimeOriginal = Exif.getTag(imageExif, "DateTimeOriginal");
                let myDate=DateTimeOriginal.split(" ");               
                let datePartOne=myDate[0].replace(/:/g,"/");
                let dateFormated = datePartOne + ' ' + myDate[1];      
                let DateTimeOriginalTimestamps =  new Date(dateFormated).getTime();
                          console.log('image info', this)
                          console.log('exif data', this.exifdata)
                          console.log('allMetaData:' ,allMetaData);
                          console.log('make:' ,make);
                          console.log('model:' ,model);
                          
                  })
    },
    testnodeExif: async function()  {

     
      require('child_process').spawn('cmd', ['/c', 'dir'])
const ep = new NodeExif.ExiftoolProcess(exiftoolBin)
const options = {
  detached: true,
  env: Object.assign({}, process.env, {
    ENVIRONMENT_VARIABLE: 1,
  }),
}
console.log('ep: ',ep);

    ep
  .open(options)
  // try to read file which does not exist
  .then(() => ep.readMetadata('filenotfound.jpg'))
  .then(console.log, console.error)
  .then(() => ep.close())
  .catch(console.error)
    },
    toggle () {
 
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

</style>
