require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-etherscan");
 require("hardhat-prettier");
 
 const Private_Key = process.env.privatekey;
 
 module.exports = {
   solidity: "0.8.0",
   networks: {
     rinkeby: {
       url: process.env.infuraID,
       accounts: [`0x${Private_Key}`],
     },
   },
   etherscan: {
     apiKey:process.env.etherscanAPI
   },
 };

