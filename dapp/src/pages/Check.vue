<template>

  <div> 
    <b-container fluid>
      <b-row class="justify-content-md-center text-white"> 
        <h3>
            Vérifier l'authenticité de la photo.
        </h3>
      </b-row>
      <b-form @submit="onSubmit" v-if="show">
         
      <b-row class="justify-content-md-center">
            <b-col>
              <b-form-file
                id="input-1"
                v-model="file"
                :state="Boolean(file)"
                @change="onFileChanged"
                accept="image/jpeg, image/png, image/gif"
                placeholder="Choose a file..."
                drop-placeholder="Drop file here..."
              >  </b-form-file>
            <div class="mt-3">Selected file: {{ file ? file.name : '' }}</div>
            <br/>
            <b-button type="submit" variant="primary">Lancer la vérification</b-button>          
        </b-col>
          <b-col>  
            <img id="previewUpload" ref="previewUpload" src="../assets/img/upload-preview.png" v-on:click="readExifImage()" />
             </b-col>
       </b-row> 
       </b-form>
      

  <b-row class="p-4 bg-dark">
    
    <b-table stacked :items="items" :busy="isBusy" ref="tableResult">
      <div slot="table-busy" class="text-center text-danger my-2">
        <b-spinner class="align-middle"></b-spinner>
        <strong>Chargement de la blockchain...</strong>
      </div>
    </b-table>   
  </b-row>
</b-container>
</div>


</template>

<script>

import {mapGetters} from 'vuex'
const ethers = require('ethers');
const Exif = require('exif-js');
export default {
  name: 'Check',
  props: {
    msg: String
  },

  data () {
    return {
      imageData: {},
      isBusy: false,
      items: [ { nom_du_photographe: '', email: '', nombre_de_photos: 0, status: '',hash_du_photographe: '0x'} ],
      selectedFile: null,
      photo: {hashAuteur: null,
              idApn: null,
              title: null,
              dateTimeOriginal: null},
      TypePhotographes: ['Independant','Collaboration','Agence'],

      file: null,
      success: false,
      name: 'BootstrapVue',
      show: true
    }
  },
  computed: {
    ...mapGetters(['dataContract','appConfig'])
  },
  watch: {

  },
  methods: {
    toggleBusy() {
        this.isBusy = !this.isBusy
    },
    toggle () {
 
    }, 
    onFileChanged (event) {
         this.selectedFile = event.target;
          if (this.selectedFile.files && this.selectedFile.files[0]) {
                var reader = new FileReader();
                reader.onload = (e) => {
                     this.imageData = e.target.result;
                }
                reader.readAsDataURL(this.selectedFile.files[0]);
                var previewUpload = document.getElementById('previewUpload');
                previewUpload.src = URL.createObjectURL(this.selectedFile.files[0]);
               
          }
    },
    onSubmit: async function(evt) {
        evt.preventDefault()
        if ( this.selectedFile.files[0] == null) {
          return false;
        }
        this.toggleBusy()
      
        console.log('items 1: ', this.items);
        await this.readExifImage()
        
        if (this.photo.hashAuteur != ''){
          this.verifPhotoContract()
        }else{
          alert('La photo ne possède pas de clé auteur')
        }
    },
    base64ToArrayBuffer (base64) {
        base64 = base64.replace(/^data\:([^\;]+)\;base64,/gmi, '');
        var binaryString = atob(base64);
        var len = binaryString.length;
        var bytes = new Uint8Array(len);
        for (var i = 0; i < len; i++) {
            bytes[i] = binaryString.charCodeAt(i);
        }
        return bytes.buffer;
    }, 
    DateToTimestamp( DateTimeOriginal) {
        let myDate=DateTimeOriginal.split(" ");               
        let datePartOne=myDate[0].replace(/:/g,"/");
        let dateFormated = datePartOne + ' ' + myDate[1];      
        let DateTimeOriginalTimestamps =  new Date(dateFormated).getTime();
        return DateTimeOriginalTimestamps;
    },
    _readExifImage: async function(){
      this.$forceUpdate();
      this.$nextTick(function () {       
        let images = this.selectedFile.files[0];
        let TitlePhoto =  images.name   
        const _this = this ;
            Exif.getData(this.$refs.previewUpload, function()  {                  
                                  
                this.allMetaData = Exif.getAllTags(this);                       
                console.log('allMetaData: ', this.allMetaData);             
                  let Copyright = Exif.getTag(this, "Copyright");
                  let DateTimeOriginal = _this.DateToTimestamp(Exif.getTag(this, "DateTimeOriginal"));
                  let Artist = Exif.getTag(this, "Artist");
                  let idApn = Exif.getTag(this, "Model");   
                  //controle des données si vide
                  if(typeof Artist  == 'undefined' ){  Artist = "Photographedujour";}
                  if(typeof Copyright  == 'undefined' ){  Copyright = ethers.utils.formatBytes32String(Artist);}
                  if(typeof TitlePhoto  == 'undefined' ){ TitlePhoto = 'inconnu';}
                  if(typeof DateTimeOriginal  == 'undefined' ){ DateTimeOriginal = '1';}
                  if(typeof idApn  == 'undefined' ){ idApn = 'inconnu';}

              _this.photo.hashAuteur = Copyright
              _this.photo.idApn = idApn
              _this.photo.dateTimeOriginal = DateTimeOriginal
              _this.photo.title = TitlePhoto
                  
            }) 
            
       })
    },
    readExifImage: function ()  {
      
      return new Promise(resolve => { 
            let images = this.selectedFile.files[0]; 
            let imageExif =  Exif.readFromBinaryFile(this.base64ToArrayBuffer(this.imageData))
            console.log('imageExif', imageExif);
            
            let Artist = imageExif.Artist
            let TitlePhoto =  images.name                   
            let Copyright = imageExif.Copyright;
            let DateTimeOriginal = this.DateToTimestamp(imageExif.DateTimeOriginal);
            let idApn = imageExif.Model;   
    
            //controle des données si vide
            if(typeof Artist  == 'undefined' ){  Artist = "Photographedujour";}
            if(typeof Copyright  == 'undefined' ){  Copyright = "Photographedujour";}

          let  tempAscii =  this.toAscii(Copyright).replace(/\u0000/g, '')
          let reverseAscii = this.fromAscii(tempAscii, 32)
          if (Copyright != reverseAscii){
                    Copyright = ethers.utils.formatBytes32String(Artist);
                    console.log('copyright', true +'=> '+ ethers.utils.parseBytes32String(Copyright));
                                   
            }
            if(typeof TitlePhoto  == 'undefined' ){ TitlePhoto = 'inconnu';}
            if(typeof DateTimeOriginal  == 'undefined' ){ DateTimeOriginal = '1';}
            if(typeof idApn  == 'undefined' ){ idApn = 'inconnu';}

            this.photo.hashAuteur = Copyright
            this.photo.idApn = idApn
            this.photo.dateTimeOriginal = DateTimeOriginal
            this.photo.title = TitlePhoto
                             
             console.log('allMetaData: ', this.photo); 
        resolve()
      })           
    },
    verifPhotoContract: async function() {
        console.log("dataContract: ", this.dataContract)
           try{
                  //Connect to contrat

                  //let address = await ethereum.enable();
                  //const provider = new ethers.providers.Web3Provider(ethereum);
                  let contratAddress = this.dataContract.address.toLowerCase();
                  let contratAbi = this.dataContract.abi
                  let contract = new ethers.Contract(contratAddress, contratAbi, this.appConfig.provider);
                 
                  let contractSigner = contract.connect(this.appConfig.signer);
                                
                  
                  console.log('photo', this.photo.dateTimeOriginal);
                    const tx = await contractSigner.existPhoto(
                                                                this.photo.dateTimeOriginal,
                                                                this.photo.hashAuteur,
                                                                this.photo.idApn,
                                                                this.photo.title,
                                                                );
                    console.log('tx:', tx);
                                                                
                    if (tx[0]) {
                          this.items[0].nom_du_photographe = tx[1]
                          this.items[0].email = tx[2]
                          this.items[0].nombre_de_photos = tx[3].toNumber() 
                          this.items[0].status = this.TypePhotographes[tx[4]]
                          this.items[0].hash_du_photographe = tx[5]
                       
                        console.log('items2: ', this.items);
                        
                     
                    } else {
                      alert("La photo n'est pas dans la dapp")
                    }
                    await this.toggleBusy()                  
                
              }catch(err){
                console.log(err);
                //alert(JSON.stringify(err));
              }
    },
    toAscii : function(hex) {
        var str = "";
        var i = 0, l = hex.length;
        if (hex.substring(0, 2) === '0x') {
            i = 2;
        }
        for (; i < l; i+=2) {
            var code = parseInt(hex.substr(i, 2), 16);
            str += String.fromCharCode(code);
        }
        return str;
    },
    fromAscii : function(str, padding) {
      var hex = '0x';
      for (var i = 0; i < str.length; i++) {
          var code = str.charCodeAt(i);
          var n = code.toString(16);
          hex += n.length < 2 ? '0' + n : n;
      }
      return hex + '0'.repeat(padding*2 - hex.length + 2);
    }


  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
table.b-table[aria-busy='false'] {
  opacity: 1;
}
table.b-table[aria-busy='true'] {
  opacity: 0.6;
}
table{
  background-color: white;
}
#previewUpload{
  height: 150px;
}
</style>
