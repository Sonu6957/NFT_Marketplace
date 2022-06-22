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
    uint private _listingId = 0 ;
    mapping (uint => Listing) private _listingmaps;
    
    enum Tokenstatus{
        Active,
        Sold,
        Cancelled
    }
    
    struct Listing{                                                          //Details in each listing
        Tokenstatus status;
        address artist;
        address owner;
        address token;
        uint tokenId;
        uint price;
    }
    
    constructor(IERC20 token){                                              //address of the deployed ERC20 token as an argument
        erctoken = token; 
        contractOwner=msg.sender;       
    }
    
    function SetRoyaltyFee(uint royalitypercentage)public{                                                     //Royalty fee setter
        require(msg.sender==contractOwner,"Only owner can change Royalty amount");
        royalityInbps = royalitypercentage*100;
        require(royalitypercentage<=975,"Royalty limit should be less that 97.5");
    }
    
    function getRoyaltyFee() public view returns(uint){                                                         ////Royalty fee getter in bps
        return royalityInbps;
    }

    function TokenListing(address newtoken, uint tokenId, uint price) public payable  {                         //To list a token
        NFTtoken = IERC721(newtoken);                                                                           // arguments:- newtoken ( address of the NFT token)
        NFTtoken.transferFrom(msg.sender,address(this),tokenId);                                                // tokenId:- tokenID of the token to be listed 
        Listing memory listing = Listing(                                                                       //price:- selling price
            Tokenstatus.Active,
            msg.sender,
            msg.sender,
            newtoken,
            tokenId,
            price );
        _listingId++;
        _listingmaps[_listingId] = listing;
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
