// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract marketplace {
    IERC721 NFTtoken;
    IERC20 erctoken;
    address contractOwner;
    uint decimals = 10**18;
    uint royalityInbps;
    
    enum Tokenstatus{
        Active,
        Sold,
        Cancelled
    }
    struct Listing{
        Tokenstatus status;
        address artist;
        address owner;
        address token;
        uint tokenId;
        uint price;
    }
    uint private _listingId = 0 ;
    mapping (uint => Listing) private _listingmaps;
    constructor(IERC20 token){
        erctoken = token; 
        contractOwner=msg.sender;       
    }
    function SetRoyaltyFee(uint royalitypercentage)public{
        require(msg.sender==contractOwner,"Only owner can change Royalty amount");
        royalityInbps = royalitypercentage*100;
        require(royalitypercentage<=975,"Royalty limit should be less that 97.5");
    }
    function getRoyaltyFee() public view returns(uint){
        return royalityInbps;
    }

    function TokenListing(address newtoken, uint tokenId, uint price) public payable  {
        NFTtoken = IERC721(newtoken);
        NFTtoken.transferFrom(msg.sender,address(this),tokenId);
        Listing memory listing = Listing(
            Tokenstatus.Active,
            msg.sender,
            msg.sender,
            newtoken,
            tokenId,
            price );
        _listingId++;
        _listingmaps[_listingId] = listing;
    }
    
    function getListing(uint listingId) public view returns (Listing memory){
        return _listingmaps[listingId];
    }
    function listingprice(uint ld) public view returns(uint){
        Listing storage listing = _listingmaps[ld];
        return listing.price;
    }
    function BuyToken(uint listingId) public payable{
        Listing storage listing = _listingmaps[listingId];
        require(listing.status==Tokenstatus.Active,"The token is not active");
        require(listing.artist!=msg.sender,"Artist cannot be the buyer");
        require(listing.owner!=msg.sender,"Seller cannot be the buyer");
        require(listing.price<=erctoken.balanceOf(msg.sender),"Insufficient balance");

        listing.status = Tokenstatus.Sold;
        
        uint platformFee = ((listing.price*decimals)/1000)*25;
        uint royaltyfee = ((getRoyaltyFee()*listing.price)/10000);
        uint finalprice =listing.price-((platformFee/decimals)+royaltyfee);
        

        NFTtoken.transferFrom(address(this),msg.sender,listing.tokenId);

        erctoken.transferFrom(msg.sender,address(this),(platformFee/decimals));
        erctoken.transferFrom(msg.sender,listing.artist,royaltyfee);
        erctoken.transferFrom(msg.sender,listing.owner,finalprice); 

        listing.owner = msg.sender;              
    }
    function CancelToken(uint listingId) public{
        Listing storage listing = _listingmaps[listingId];
        require(listing.status == Tokenstatus.Active,"The token is not active");
        require(msg.sender==listing.owner,"Only the owner can delist the token");
        listing.status = Tokenstatus.Cancelled;
        NFTtoken.transferFrom(address(this),listing.owner,listing.tokenId);
    }
}
