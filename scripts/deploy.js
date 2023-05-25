
const hre = require("hardhat");

async function main() {
  const YvesSaintLaurent = await hre.ethers.getContractFactory("YvesSaintLaurent");
  const yvesSaintLaurent = await YvesSaintLaurent.deploy(850, 3);

  await yvesSaintLaurent.deployed();

  console.log("YvesSaintLaurent Token deployed: ", yvesSaintLaurent.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
