// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * @title TurtleTank contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */

contract TurtleTanksPass2 is ERC721, ERC721Enumerable, Ownable {
    string public PROVENANCE;
    uint256 public tokenPrice = 50000000000000; // 0.00005 ETH
     
    uint256 public MAX_TOKENS = 10000;
    bool public saleIsActive = false;

    string public _baseURIextended;
    uint public teamreserve = 200;
    uint public presaleTokens = 10;
    
    mapping(address => uint) private reserveInfluencer;
    
    uint public numberOfTurtleBought = 0;
    mapping(address => uint) public turtleBoughtBy;

    constructor() ERC721("Turtle Tanks", "TRLT") {
    }

    // CHANGED: needed to resolve conflicting fns in ERC721 and ERC721Enumerable
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // CHANGED: needed to resolve conflicting fns in ERC721 and ERC721Enumerable
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // CHANGED: added to account for changes in openzeppelin versions
    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    // CHANGED: added to account for changes in openzeppelin versions
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
        
    }

    function setProvenance(string memory provenance) public onlyOwner {
        PROVENANCE = provenance;
    }
   
    function reserveTeam(address _to, uint256 _reserveAmount) public {    
        require(totalSupply() + _reserveAmount <= MAX_TOKENS, "Reserve would exceed max supply of tokens");
        uint supply = totalSupply();
        if (msg.sender == owner()){
            require(_reserveAmount > 0 && _reserveAmount <= teamreserve, "Not enough reserve left for team");
            teamreserve = teamreserve - _reserveAmount; 
        }else{
            require(reserveInfluencer[msg.sender] + _reserveAmount >= 0, "Not enough reserve left for influencer");
            reserveInfluencer[msg.sender] -= _reserveAmount;
        }
        for (uint i = 0; i < _reserveAmount; i++) {
            _safeMint(_to, supply + i);
        }
    }

    // set free mintable by influencer
    function addInfluencer (address to, uint256 tokensToReserve) public onlyOwner{
        reserveInfluencer[to] = tokensToReserve;
    }
    
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function getReserve(uint numberOfTokens) public payable{
        require(saleIsActive, "Sale must be active to reserve Tokens");
        require(numberOfTurtleBought + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply of tokens");
        require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");

        // free sale or not
        if (numberOfTurtleBought + numberOfTokens <= 100){  
            require(turtleBoughtBy[msg.sender] + numberOfTokens <= 1, "Already reserved enough free Animals");
        }else {
            require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");

            // Last tokens of presale -> stop presale
            if (numberOfTurtleBought + numberOfTokens >= presaleTokens && numberOfTurtleBought < presaleTokens){  
                saleIsActive = false;
            }
        }

        turtleBoughtBy[msg.sender] += numberOfTokens;
        numberOfTurtleBought += numberOfTokens;
    }
    
    // doesnt not work on polygonscan 
    function getClaimable() public view returns(uint){
        return (turtleBoughtBy[msg.sender]) ;
    }

    function claim(uint numberOfTokens) public{
        require(numberOfTokens <= turtleBoughtBy[msg.sender], "You have not reserved enough turtles");
        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_TOKENS) {
                _safeMint(msg.sender, mintIndex);
            }
        }
        turtleBoughtBy[msg.sender] -= numberOfTokens;
    }


    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

}