// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const erc20compile = await hre.ethers.getContractFactory("NewToken");
  const erc20deploy = await erc20compile.deploy();
  const NFTcompile = await hre.ethers.getContractFactory("NFT");
  const NFTdeploy = await NFTcompile.deploy();
  


  await erc20deploy.deployed();
  const Marketplacecompile = await hre.ethers.getContractFactory("marketplace");
  const Marketplacedeploy = await Marketplacecompile.deploy(erc20deploy.address);

  console.log("erc20 deployed to:", erc20deploy.address);
  console.log("NFT deployed to:", NFTdeploy.address);
  console.log(" Marketplace deployed to:", Marketplacedeploy.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
