pragma solidity 0.5.7;

pragma experimental ABIEncoderV2;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Register {

    event PhotoAdded(string title, bytes32 hash_auteur, uint date_today, bytes32 hash_photo);
    event InscriptionPhotographe(bool value);
    event CheckPhoto(bool value);
    event ConnexionContract (bool connected, string nom);

	using SafeMath for uint;
	address payable utilisateur;
    uint public id_photo = 0;
    mapping(address => int) ratings;
    constructor() public { utilisateur = msg.sender; }

    struct photographe {
        string nom;
        string email;
        uint256 nbPhotos;
        TypePhotographe _typePhotographe;
        uint256 ratingsPositif;
        uint256 ratingsNegatif;
        bool isValue;
    }

    enum TypePhotographe{
        Independant,
        Collaboration,
        Agence,
        Modele,
        Client
    }

    enum Orientation{
        Positif,
        Negatif
    }

    struct photo{
        string title;
        address utilisateur;
        uint date_created;
        uint date_import;
        bytes32 hash_auteur;
        string url_ipfs;
        string apn;
        uint id_photo;
        bool isValue;
    }

    bytes32[] public photos;
    address[] public utilisateurs;

    mapping (address => photographe) public _utilisateur;
    mapping (bytes32 => photo) public _photo;

    function inscriptionPhotographe( string memory name, string memory mail, TypePhotographe _typePhotographe) public {
        require(!isInscrit(utilisateur),"Vous êtes déjà inscrit");
        _utilisateur[msg.sender].nom = name;
        _utilisateur[msg.sender].email = mail;
        _utilisateur[msg.sender]._typePhotographe = _typePhotographe;
        _utilisateur[msg.sender].isValue = true;
        utilisateurs.push(msg.sender);

        emit InscriptionPhotographe(true);
    }

    function ajoutePhoto(string memory _title, uint _date_created, bytes32 hash_auteur,  string memory id_apn , string memory url_ipfs )public  payable {
        require(isInscrit(utilisateur),"Vous n'êtes pas inscrit");
        uint date_today = now;
        bytes32 hash_photo = keccak256(abi.encodePacked( _date_created, hash_auteur, id_apn, _title ));
              
        photos.push(hash_photo);
       
        _photo[hash_photo].title = _title;       
        _photo[hash_photo].utilisateur = msg.sender;
        _photo[hash_photo].date_created = _date_created;
        _photo[hash_photo].date_import = date_today;
        _photo[hash_photo].id_photo = id_photo;
        _photo[hash_photo].apn = id_apn;
        _photo[hash_photo].hash_auteur = hash_auteur; 
        _photo[hash_photo].url_ipfs = url_ipfs; 
        _photo[hash_photo].isValue = true; 

        _utilisateur[msg.sender].nbPhotos = _utilisateur[msg.sender].nbPhotos.add(1);        
        id_photo = id_photo.add(1);
        emit PhotoAdded(_title, hash_auteur, date_today, hash_photo);
       
    }
    function connexion(address hash_photographe) public view returns(bool, string memory) {
        bool connected  = false ;
        string memory connectedNom = 'inconnu';
        connected = isInscrit(hash_photographe);
        if(connected == true){
            connectedNom =  _utilisateur[hash_photographe].nom;
        }
        return (connected, connectedNom);
    }

    function isInscrit(address hash_photographe) private view returns (bool){
        bool value = false;
        if(hash_photographe != address(0)){
            if(_utilisateur[hash_photographe].isValue){
                    value = true;
            }    
        }
          return value;
    }

    function existPhoto(uint _date_created, 
                        bytes32 _hash_auteur, 
                        string memory _id_apn, 
                        string memory _title ) public view returns (
                                                             bool,
                                                             string memory,
                                                             string memory,
                                                             uint,
                                                             TypePhotographe,
                                                             address){
        
        bytes32 _hash_photo = keccak256(abi.encodePacked( _date_created, _hash_auteur, _id_apn, _title )) ;
        bool value = false;
        if(_photo[_hash_photo].isValue){
                value = true;
        }    
        address photographeAddress = _photo[_hash_photo].utilisateur;
        return (value,
                _utilisateur[photographeAddress].nom,
                _utilisateur[photographeAddress].email,
                _utilisateur[photographeAddress].nbPhotos,
                _utilisateur[photographeAddress]._typePhotographe,
                _photo[_hash_photo].utilisateur);
    }

    function getImage(bytes32 hash_photo) public view returns (string memory, address, uint, uint, bytes32, string memory){
        return (_photo[hash_photo].title,
                _photo[hash_photo].utilisateur,
                _photo[hash_photo].date_created,
                _photo[hash_photo].date_import,
                _photo[hash_photo].hash_auteur,
                _photo[hash_photo].url_ipfs);
            }
            
    function changeRepution(address _userAddress, int _delta, Orientation _signed ) public {
        require (isInscrit(msg.sender))

        _utilisateur[photographeAddress]._typePhotographe,

        if(_signed  == Positif){
            _utilisateur[photographeAddress].ratingsPositif.add(_delta);
        }else{
            _utilisateur[photographeAddress].ratingsNegatif.add(_delta);
        }
        
        ratings[_userAddress].add(_delta);
        ratings[_userAddress].add(_delta);
    }

    function getRepution(address _userAddress) public view returns (int) {
           
        int rating = _utilisateur[photographeAddress].ratingsPositif.sub( _utilisateur[photographeAddress].ratingsNegatif);
       
        return ratings;
    }
 
}