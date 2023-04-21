// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// INTERNAL IMPORT FOR THE NFT OPENZEPPELINE
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ERC721/ERC721.sol";

import "hardhat/console.sol";

// Contract-1 : NFT Selling and Buying
contract NFTMarketPlace is ERC721URIStorage{
  // Making counters for the NFT
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;
  Counters.Counter private _itemsSold;
  uint256 listingPrice=0.0015 ether;
  address payable owner;

  // Making the NFT market item structure
  mapping(uint256=>MarketItem) private idMarketItem;
  struct MarketItem{
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
  }

  // Event: Stores the information of created NFT
  event idMarketItemCreated(
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );

  // Modifier: for updateListingPrice function 
  modifier onlyOwner{
    require(
      msg.sender==owner,"Only owner of the marketplace can change the listing price"
    );
    _;
  }

  // Constructor: Initialise states values
  constructor() ERC721("NFT Metaverse Token","MYNFT"){
    owner==payable(msg.sender);
  }

  // Function: to update the listing price for the NFT that the NFT owner will pay us for listing an item on our market place
  function updateListingPrice(uint256 _listingPrice) public payable onlyOwner{
    listingPrice=_listingPrice;
  }
  // Function: to get the listing price data of an NFT
  function getListingPrice() public view returns (uint256){
    return listingPrice;
  }






  // Function: Create NFT Token Function


}