// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArbiNFT is ERC721 { //Add project Name
    using Counters for Counters.Counter;

    //Değişkenler
    uint32 totalSupply = 4000; //Arz
    uint8 maxPerAccount = 4; // Kişi başı üst limit
    uint mintTime; // Mint süresi bloklar ile hesaplandı dakikada 4 blok üretiliyor
    string private baseURI = "ipfs://QmWFFmKz6U2FFQmnwQhBUFskg34cgsWzXNgr2EfZS797BH/";  //basuUri 
    address owner;
    uint endedBlock;
    mapping(address => uint8) public mintCount; //Cüzdan Başı Mint Limiti


    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("NFT_NAME", "NFT_SYMBOL") {
        owner = msg.sender;
        endedBlock = block.timestamp + mintTime;
    }

    

    function safeMint() public payable {
        require(block.timestamp < endedBlock,"Timeout");  //Süre kontrolü
        require(_tokenIdCounter.current() < totalSupply,"Sold out"); //Arz Kontrolü
        require(mintCount[msg.sender] < 4); // Cüzdan limiti
        mintCount[msg.sender]++;
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
          return baseURI;
    }

    function setBaseURI(string memory URI) external onlyOwner{
          baseURI = URI;
    }


    //Modifier for Admin 
    modifier onlyOwner() {
            require(msg.sender == owner, "Not owner");
            _;
    }

    function getDonate(address payable recipient, uint256 amount) public onlyOwner{
        (bool succeed, bytes memory data) = recipient.call{value: amount}("");
        require(succeed, "Have a problem");
      }

}
