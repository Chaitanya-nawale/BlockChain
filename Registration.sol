pragma solidity ^0.6.6;

contract Registration {
    
    address chairperson;
    struct Person {
        string name;
        uint256 personalCount;
    }
    
    uint256 private authorityCount;
    mapping(address=>Person) person;
    uint256 private populationCount;
    
    constructor( string memory _name, uint256 _population) public {
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

    function registerPerson(address _authority, string memory _name) validateCaller invalidAuthority(_authority) public {
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
}
