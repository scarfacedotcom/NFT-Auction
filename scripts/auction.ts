import { ethers } from "hardhat";

async function main() {
  

  const NFT_Auction = await ethers.getContractFactory("NFT_Auction");
  const nft_Auction = await NFT_Auction.deploy();

  await nft_Auction.deployed();

  console.log(
    `Auction Contract has been deployed to ${nft_Auction.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
