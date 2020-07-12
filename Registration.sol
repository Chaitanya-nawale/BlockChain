pragma solidity ^0.6.6;

contract Registration {
    
    address chairperson;
    struct Person {
        string name;
        uint256 personalCount;
    }
    
    uint256 private authorityCount;
    mapping(address=>Person) private person;
    mapping(bytes32=>bool) private birthCertificate;
    mapping(bytes32=>bool) private deathCertificate;
    uint256 private populationCount;
    
    constructor( string memory _name, uint256 _population) validName(_name) validPopulation(_population) public {
        chairperson = msg.sender;
        person[chairperson].name = _name;
        authorityCount = 1;
        populationCount = _population;
    }
    
    modifier validateCaller() {
        require(msg.sender == chairperson);
        _;
    }
    
    modifier validateAuthority(address _authority) {
        require(keccak256(bytes(person[_authority].name)) != keccak256(bytes("")));
        _;
    }
    
    modifier invalidAuthority(address _authority) {
        require(keccak256(bytes(person[_authority].name)) == keccak256(bytes("")));
        _;
    }
    
    modifier validName(string memory _name) {
        require(keccak256(bytes(_name) )!= keccak256(bytes("")));
        _;
    }
    
    modifier validPopulation(uint256 pop) {
        require(pop>=0);
        _;
    }

    function registerPerson(address _authority, string memory _name) validateCaller invalidAuthority(_authority) validName(_name) public {
        person[_authority].name = _name;
        person[_authority].personalCount = 0;
        authorityCount += 1;
    }
    
    function removeAuthority(address _authority) validateCaller validateAuthority(_authority) public {
        delete person[_authority];
        authorityCount -= 1;
    }
    
    function changeChairPerson(address _authority) validateCaller validateAuthority(_authority) public {
        chairperson = _authority;
    }
    
    function getChairpersonName() validateAuthority(msg.sender) public view returns (string memory) {
        return person[chairperson].name;
    }
    
    function getAuthorityName(address _authority) validateAuthority(_authority) public view returns (string memory){
        return person[_authority].name;
    }
    
    function getPopulation() public view returns (uint256){
        return populationCount;
    }
    
    function getTotalNumberOfAuthorities() public view returns (uint256){
        return  authorityCount;
    }
    
/*    function getHash(string memory a,string memory b,string memory c,string memory d,string memory e ) public view returns (bytes32){
        return sha256(abi.encodePacked(a, b, c, d, e));
    }
    
    function getHashs(string memory a,string memory b,string memory c,string memory d,string memory e ) public view returns (string memory){
        return string(abi.encodePacked(a, b, c, d, e));
    }
*/    
    function generateBirthCertificate(string memory _name,string memory _fatherName,string memory _motherName,string memory timestamp,string memory sex )  validateAuthority(msg.sender)  public{
        bytes32 hashPerson= sha256(abi.encodePacked(_name,_fatherName,_motherName,timestamp,sex));
        if(birthCertificate[hashPerson]!= true)
        {
            birthCertificate[hashPerson]= true;
            populationCount+=1;
            person[msg.sender].personalCount +=1;
        }
    }
    
    function generateDeathCertificate(string memory _name,string memory _fatherName,string memory _motherName,string memory timestamp,string memory sex )  validateAuthority(msg.sender) public{
        bytes32 hashPerson= sha256(abi.encodePacked(_name,_fatherName,_motherName,timestamp,sex));
        if(deathCertificate[hashPerson]!= true)
        {
            deathCertificate[hashPerson]= true;
            populationCount-=1;
        }
    }
    
  /*  function validateBirthCertificateByDetails(string memory _name,string memory _fatherName,string memory _motherName,string memory timestamp,string memory sex )  validateAuthority(msg.sender) public view returns (bool){
        bytes32 hashPerson= sha256(abi.encodePacked(_name,_fatherName,_motherName,timestamp,sex));
        return birthCertificate[hashPerson];
    }
    
    function validateDeathCertificateByDetails(string memory _name,string memory _fatherName,string memory _motherName,string memory timestamp,string memory sex )  validateAuthority(msg.sender) public view returns (bool){
        bytes32 hashPerson= sha256(abi.encodePacked(_name,_fatherName,_motherName,timestamp,sex));
        return deathCertificate[hashPerson];
    }
    
*/   function validateBirthCertificateByHash(bytes32 _hash) validateAuthority(msg.sender) public view returns (bool){
        return birthCertificate[_hash];
    }
    
    function validateDeathCertificateByHash(bytes32 _hash)  validateAuthority(msg.sender) public view returns (bool){
        return deathCertificate[_hash];
    }
    
}
