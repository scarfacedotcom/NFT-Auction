import { ethers } from "hardhat";

async function main() {
  

  const NFT = await ethers.getContractFactory("AuctionToken");
  const auctionToken = await NFT.deploy("ScarNFT", "SFN");

  await auctionToken.deployed();

  console.log(
    `NFT Contract has been deployed to ${auctionToken.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
