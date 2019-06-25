<template>
<div>
  <b-container fluid>
    <b-row class="justify-content-md-center text-white">
       <h3>
          Import de la photographie
       </h3>
    </b-row>
    <b-row class="justify-content-md-center">
      <b-col>
        <b-form @submit="onSubmit"  v-if="show">
          
            <b-form-file             
              @change="onFileChanged"
              :file-name-formatter="formatNames"
              accept="image/jpeg, image/png, image/gif"
              v-model="file"          
              :state="Boolean(file)"
              placeholder="Choose a file..."
              drop-placeholder="Drop file here..."
            ></b-form-file>
            <div class="mt-3">Selected file: {{ file ? file.name : '' }}</div>
            
            <b-button type="submit" variant="primary">Envoyer la photo</b-button>
        </b-form>
      </b-col>
      <b-col>
        <img id="previewUpload" ref="previewUpload" src="../assets/img/upload-preview.png" v-on:click="readExifImage()" />
      </b-col>
    </b-row>
    <b-row class="justify-content-md-center" v-if="etapeImport === 'A'">
      <b-img src="https://picsum.photos/300/150/?image=823" fluid alt="Fluid image" ></b-img>
    </b-row>
    <b-row class="justify-content-md-center" align-v="center" v-if="etapeImport === 'B'">
      
      <b-col>
         <b-spinner label="Loading in ipfs..." ></b-spinner>
      </b-col>
       <b-col>
      <b-img :src="imageData" class="preview blur" fluid alt=" image Ipfs" ></b-img>
      </b-col>
    </b-row>
    <b-row class="justify-content-md-center" align-v="center" v-if="etapeImport === 'C'">
      <b-col>
        <b-img :src="urlImageIpfs" class="preview" fluid alt="Fluid image" ></b-img>
      </b-col>
       <b-col>
        <img src="../assets/img/fleche.png" class="preview-fleche" fluid alt="fleche" />
      </b-col>
      <b-col>         
        <b-spinner v-if="imgHeberger" style="width: 3rem; height: 3rem;" label="Large Spinner"></b-spinner>
        <b-button v-else variant="outline-primary" size="lg">
          <b-link :href="urlImageIpfs" target="_blank">Image hébergé</b-link>
        </b-button>
      </b-col> 
    </b-row>
    <b-row class="justify-content-md-center" align-v="center" v-if="etapeImport === 'D'">
      <b-col>
        <img :src="urlImageIpfs" class="preview" fluid alt="Fluid image" />
      </b-col>
      <b-col>
        <img src="../assets/img/fleche.png" class="preview-fleche" fluid alt="fleche" />
      </b-col>
      <b-col>          
        <b-button variant="outline-primary" size="lg">
            <b-link  :href="urlImageIpfs" target="_blank">Image hébergé</b-link>
        </b-button>
      </b-col> 
      <b-col>
        <img src="../assets/img/fleche.png" class="preview-fleche" fluid alt="fleche" />
      </b-col>
      <b-col>   
        
        <b-button  variant="outline-primary" size="lg">
          Image sur la blockchain
        </b-button>
      </b-col> 
    </b-row>
 </b-container>
</div>
  
   

</template>

<script>
import {mapGetters} from 'vuex'
const Exif = require('exif-js');
const ethers = require('ethers');
export default {
  name: 'Import',
  props: {
    msg: String
  },

  data () {
    return {
      name: 'BootstrapVue',
      file: null, //nom du fichier dans le form.input.file
      selectedFile: null,
      imageData: null,
      hashImageImport: null,
      urlImageIpfs:"#",
      dataPhotoExifContract: [],
      show: true,
      imgHeberger: true,
      etapeImport: 'A' // etape d'import de la photo, ordre alphabetique
    }
  },
  watch: {

  },
  computed: {
    ...mapGetters(['dataContract','appConfig'])
  },
  mounted() {
    const jsIpfs1 = document.createElement("script");
    jsIpfs1.setAttribute(
      "src",
      "https://unpkg.com/ipfs@0.34.0/dist/index.min.js"
    );
    jsIpfs1.async = true;    
    document.head.appendChild(jsIpfs1);
  },
  methods: {
    formatNames(file) {
        if (file.target.files.length === 1) {
          return file.target.files[0].name
        } else {
          return `${file.target.files.length} files selected`
        }
    },
    toggle () {
 
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
    onFileChanged (event) {
         this.selectedFile = event.target;
            // Ensure that you have a file before attempting to read it
            if (this.selectedFile.files && this.selectedFile.files[0]) {
              console.log('image )))))');
                // create a new FileReader to read this image and convert to base64 format
                var reader = new FileReader();
                // Define a callback function to run, when FileReader finishes its job
                reader.onload = (e) => {
                  console.log('image', e);
                  
                    // Note: arrow function used here, so that "this.imageData" refers to the imageData of Vue component
                    // Read image as base64 and set to imageData
                    this.imageData = e.target.result;
                    
                }
                
                // Start the reader job - read file as a data url (base64 format)
                reader.readAsDataURL(this.selectedFile.files[0]);
              
                var previewUpload = document.getElementById('previewUpload');
                previewUpload.src = URL.createObjectURL(this.selectedFile.files[0]);
                

              this.$set(this.$refs.previewUpload, 'src', URL.createObjectURL(this.selectedFile.files[0]))
         
            }        
    },
    readexif(){
        this.$forceUpdate();
      this.$nextTick(function () {       
     
          console.log('ref: ',this.$refs.previewUpload);
            Exif.getData(this.$refs.previewUpload, function()  {

                this.allMetaData = Exif.getAllTags(this);              
                console.log('allMetaData: ', this.allMetaData);
                var model = Exif.getTag(this, "Copyright");
                console.log('model:' ,model);
            })            
      })
    },
    onSubmit(evt) {
        evt.preventDefault()
        this.etapeImport = 'B'
        this.importIpfs()

    },
    importIpfs (){        
          const node = new Ipfs({ start: false })
          node.on('ready', () => {
          console.log('Node is ready to use!')
        
          node.start(error => {
            if (error) {
              return console.error('Node failed to start!', error)
            }
            console.log('Node started!')
          })

            const image = this.selectedFile.files[0];
            const image_name = this.selectedFile.files[0].name;
            console.log("name image: ",this.selectedFile.files[0].name);

            let reader = new FileReader();
            reader.readAsArrayBuffer(image);
            console.log(image);
            
            reader.onloadend = () => {              
              node.add(new node.types.Buffer.from(reader.result)).then((r) => {
                  console.log("hash: ", r[0])
                  this.hashImageImport = r[0].hash;
                  console.log("hashImageImport: ",this.hashImageImport);
                  //document.getElementById("afficherResultat_hashImage").innerHTML = hashImageImport
                  this.urlImageIpfs = 'https://ipfs.io/ipfs/' + this.hashImageImport
                  console.log("link: ", 'https://ipfs.io/ipfs/' + this.hashImageImport)
                  this.uploadFileToContract(); 
                })   
            }  
                       
           
        });
      },
      uploadFileToContract: async function()  {
        this.etapeImport = 'C'
        console.log("upload_file_to_contract", true)
        console.log("dataContract: ", this.dataContract)
           try{
                  //Connect to contrat

                  let contratAddress = this.dataContract.address.toLowerCase();
                  let contratAbi = this.dataContract.abi
                  let contract = new ethers.Contract(contratAddress, contratAbi, this.appConfig.provider);
                  console.log("adresse contract: "+contratAddress);
                  console.log("address: "+ this.appConfig.nom);
                  console.log("hashImageImport: "+this.hashImageImport)
                  //dapp = { contratAddress, provider, contract };
                   let contractSigner =  contract.connect(this.appConfig.signer);
                  
                   await this.readExifImage();
                   console.log('dataPhotoExifContract', this.dataPhotoExifContract[0]);                    
                   console.log('dataPhotoExifContract', this.dataPhotoExifContract[0]);
                    
                   for (let i = 0; i < this.selectedFile.files.length; i++) {
                     
                      const tx = await contractSigner.ajoutePhoto(this.dataPhotoExifContract[i].TitlePhoto,
                                                                  this.dataPhotoExifContract[i].DateTimeOriginal,
                                                                  this.dataPhotoExifContract[i].Copyright,
                                                                  this.dataPhotoExifContract[i].Model,
                                                                  this.hashImageImport
                                                                  );
                    
                      tx.wait().then(() =>
                        {
                          this.imgHeberger = false;
                          alert("Image hash saved on blockchain: " + this.hashImageImport)
                          
                          this.etapeImport = 'D'
                        }
                      );
                  // }
                    }
                 
                
              }catch(err){
                console.log(err);
              }
      },
      
    readExifImageOld: function (exif)  { 
            let images = this.selectedFile.files[0];
            
                console.log('images: ',images);
            //images.forEach(image => {
          /*  for(let id in images){  
              let image = images[id]
              const reader = new FileReader();
              reader.readAsArrayBuffer(this.$refs["photoUpload"]);
              reader.onloadend = () => {
                reader.result
              }*/
             // alert (this.imageData);
              //alert(this.$refs["photoUpload"]);
             // alert (document.getElementsByClassName("img1"));
              //Exif.getData(image, (imageExif) => { 
                
             console.log(this.imageData);
              let imageExif =  Exif.readFromBinaryFile(this.base64ToArrayBuffer(this.imageData))
              console.log('imageExif:' ,imageExif);
                  let TitlePhoto =  images.name                   
                  let Copyright = imageExif.Copyright;
                  let DateTimeOriginal = this.DateToTimestamp(imageExif.DateTimeOriginal);
                  let Artist = imageExif.Artist;
                  let Model = imageExif.Model;   
                  //controle des données si vide
                  if(typeof Artist  == 'undefined' ){  Artist = "Photographedujour";}
                  if(typeof Copyright  == 'undefined' ){  Copyright = ethers.utils.formatBytes32String(Artist);}
                  if(typeof TitlePhoto  == 'undefined' ){ TitlePhoto = 'inconnu';}
                  if(typeof DateTimeOriginal  == 'undefined' ){ DateTimeOriginal = '1';}
                  if(typeof Model  == 'undefined' ){ Model = 'inconnu';}
              this.dataPhotoExifContract.push( {Copyright, DateTimeOriginal, Artist, Model, TitlePhoto})
            
            
              
               
            /*   
               Exif.getData(this.base64ToArrayBuffer(this.imageData), (imageExif) => { 
                  let allMetaData = Exif.getAllTags(imageExif);
                  
                  console.log('allMetaData: ',allMetaData);
                 
                  let Copyright = Exif.getTag(imageExif, "Copyright");
                 alert (Copyright)
                   let DateTimeOriginal = this.DateToTimestamp(Exif.getTag(imageExif, "DateTimeOriginal"));
                  let Artist = Exif.getTag(imageExif, "Artist");
                  let Model = Exif.getTag(imageExif, "Model");

                  this.dataPhotoExifContract.push( {Copyright, DateTimeOriginal, Artist, Model, titlePhoto})
              })*/
           // };
            
     
    },
    readExifImage:  function() {
      return new Promise(resolve => {  
      console.log('document.getElementById:',document.getElementById("previewUpload"));
      console.log('this.$refs.previewUpload:',this.$refs.previewUpload);
      
      //console.log(document.getElementById("previewUpload"));
      this.$forceUpdate();
      let images = this.selectedFile.files[0];
      let TitlePhoto =  images.name   
      const _this = this ;
          console.log('ref: ',this.$refs.previewUpload);
            Exif.getData(this.$refs.previewUpload, function()  {
                  let allMetaData = Exif.getAllTags(this);
                  //console.log('allMetaData: ',this);
                  //console.log('allMetaData: ',_this);
                                                    
                  let Copyright = Exif.getTag(this, "Copyright");
                  let DateTimeOriginal = _this.DateToTimestamp(Exif.getTag(this, "DateTimeOriginal"));
                  let Artist = Exif.getTag(this, "Artist");
                  let Model = Exif.getTag(this, "Model");   
                  //controle des données si vide
                  if(typeof Artist  == 'undefined' ){  Artist = "Photographedujour";}
                  if(typeof Copyright  == 'undefined' ){  Copyright = "Photographedujour";}
                    let  tempAscii =  _this.toAscii(Copyright).replace(/\u0000/g, '')
                    let reverseAscii = _this.fromAscii(tempAscii, 32)
                   console.log('tempAscii ',tempAscii);
                   console.log('reverseAscii ',reverseAscii);
                   
                   if (Copyright != reverseAscii){
                        Copyright = ethers.utils.formatBytes32String(Artist);
                        console.log('copyright', true +'=> '+ ethers.utils.parseBytes32String(Copyright));
                   }
                  if(typeof TitlePhoto  == 'undefined' ){ TitlePhoto = 'inconnu';}
                  if(typeof DateTimeOriginal  == 'undefined' ){ DateTimeOriginal = '1';}
                  if(typeof Model  == 'undefined' ){ Model = 'inconnu';}

            _this.dataPhotoExifContract.unshift( {Copyright, DateTimeOriginal, Artist, Model, TitlePhoto})
            console.log('dataPhotoExifContract_exif: ', _this.dataPhotoExifContract);  
           resolve() 
               
      })
      })
    },
    DateToTimestamp( DateTimeOriginal) {
        let myDate=DateTimeOriginal.split(" ");               
        let datePartOne=myDate[0].replace(/:/g,"/");
        let dateFormated = datePartOne + ' ' + myDate[1];      
        let DateTimeOriginalTimestamps =  new Date(dateFormated).getTime();
        return DateTimeOriginalTimestamps;
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
.preview {
    width: 200px;
    background-color: white;
    border: 1px solid #DDD;
    padding: 5px;
}
.preview-fleche{
  width: 100px;
}
.blur {  
  filter: blur(8px);
  -webkit-filter: blur(8px);
}

#previewUpload{
  /*width: 150px;*/
  height: 150px;
}
</style>
