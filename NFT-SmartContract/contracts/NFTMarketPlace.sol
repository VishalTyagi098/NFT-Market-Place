// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// INTERNAL IMPORT FOR THE NFT OPENZEPPELINE
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ERC721/ERC721.sol";

import "hardhat/console.sol";

// Contract-1 : NFT Selling and Buying
contract NFTMarketPlace is ERC721URIStorage{
  //1. Initials states and functions for the MARKETPLACE 


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

  // Event: Stores the information of created NFT and whenever a transfer occurs this event should be called to set the state of the NFT
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



  //2. NFT creation by the sellers


  // Function: Create NFT(non-fungible TOKEN) token id
  function createToken(string memory tokenURI,uint256 price ) public payable returns(uint256){
    _tokenIds.increment();

    uint256 newTokenId=_tokenIds.current();
    
    _mint(msg.sender,newTokenId);
    _setTokenURI(newTokenId,tokenURI);

    createMarketItem(newTokenId,price);

    return newTokenId;
  }

  // Function: Create Market item (in the form of NFT)
  function createMarketItem(uint256 tokenId,uint price) private{
    // testing
    require(price>0, "Price must be atleast 1");
    require(msg.value==listingPrice, "Price must be equal to listing price");

    //creating market item
    idMarketItem[tokenId]=MarketItem(
      tokenId,
      payable(msg.sender),
      payable(address(this)),
      price,
      false
    );

    // perform transfer
    _transfer(msg.sender,address(this),tokenId);

    // calling the event to tell the contract that transaction occured with what value and save that data
    emit idMarketItemCreated(tokenId, msg.sender, address(this), price, false);
  }

  // Function: Resale NFT
  function resaleToken(uint256 tokenId, uint256 price) public payable{
    // testing
    require(idMarketItem[tokenId].owner==msg.sender, "Only item owner can perform this operation");
    require(msg.value==listingPrice,"Price must be equal to listing price");

    // change values of the market item
    idMarketItem[tokenId].sold=false;
    idMarketItem[tokenId].price=price;
    idMarketItem[tokenId].seller=payable(msg.sender);
    idMarketItem[tokenId].owner=payable(address(this));

    // decrement total NFTs count
    _itemsSold.decrement();

    // perform transfer
    _transfer(msg.sender,address(this),tokenId);

  }
}