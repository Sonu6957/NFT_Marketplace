# NFT Marketplace

A digital marketplace for purchasing and selling NFTs is known as an NFT marketplace. People can use these platforms to store and show their NFTs, as well as sell them for bitcoin or cash. Some NFT exchanges also allow users to mint their own NFTs right on the platform.
## Description
This project demonstrates the working of NFT buying and selling with the a customized ERC20 token. The transactions occur based on the amount of token a given wallet has 
Instead of Eth, the transaction is controlled with the transfer of the token.The amount gets distributed among platform and as a royalty to the creator.
## How to Install and Run the Project
* Step 1: Use remix, truffle, or Hardhat to deploy ERC20.sol. This adds 100 million TestTokens to your wallet.
* Step 2: Using the tools indicated in step 1, deploy NFT.sol  and mint a token on your account.
* Step 3: Using the tools indicated in step 1, deploy Marketplace.sol using ERC20.sol contract address. 
* Step 4: Approve Marketplace contract on both ERC20 and NFT contracts to transact your tokens or NFTs.
* Step 5: List an NFT in Marketplace using the contract address of NFT.
* Step 6: Buy the given token with the amount mentioned.
* Step 7:- (Optional) Call the "balanceOf" method in the ERC20.sol contract to check for the allocated tokens for the required addresses.
## Contract Verification
Here are the links for the contract verification and transactions on each
* ERC20:- https://rinkeby.etherscan.io/address/0x42739C8D2b74818Cb2a086ce3c67324A3462D380#code
* NFT:- https://rinkeby.etherscan.io/address/0xA7Dda1ff5Dd45A979c19371A9F2DEdff1c923c4B
* Marketplace:- https://rinkeby.etherscan.io/address/0xa5e72841B0459D9F4E1f17bf71e112e389c70181#code
