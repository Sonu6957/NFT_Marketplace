// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721("NFTtoken","NFTT"){
    uint private tokenId =0;
    function mint() public returns(uint){
        tokenId++;
        _mint(msg.sender,tokenId);
        return tokenId;
    }
}
