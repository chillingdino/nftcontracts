// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * @title TurtleTank contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */

contract TurtleTanks is ERC721, ERC721Enumerable, Ownable {
    string public PROVENANCE;
    uint256 public tokenPrice = 500000000000000; // 0.0005 ETH
    uint256 public MAX_TOKENS = 10000;
    bool public saleIsActive = false;

    string public _baseURIextended;
    uint public teamreserve = 200;
    uint public presaleTokens = 10;
    
    mapping(address => uint) private freeTokenMinted;
    mapping(address => uint) private reserveInfluencer;


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
    //if owner -> mint for team
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

    function setPrice(uint256 newPrice) public onlyOwner {
        require (tokenPrice < newPrice, "new price must be lower than current price");
        tokenPrice = newPrice;
    }
    
    function mint(uint numberOfTokens) public payable { 
        uint tokensupply = totalSupply();
        require(saleIsActive, "Sale must be active to mint Tokens");
        require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply of tokens");

        // Free sale
        
        if (tokensupply + numberOfTokens <= 100){  
            require(freeTokenMinted[msg.sender] + numberOfTokens <= 1, "Already minted enough free Animals");
            // Update the free given
            freeTokenMinted[msg.sender] += numberOfTokens;  
        }else {
            require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");

            // Last tokens of presale -> stop presale
            if (tokensupply + numberOfTokens >= presaleTokens && tokensupply < presaleTokens){  
                saleIsActive = false;
            }
        }

        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_TOKENS) {
                _safeMint(msg.sender, mintIndex);
            }
        }
        
    }
    

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

}