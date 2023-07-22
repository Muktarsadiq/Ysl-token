
const hre = require("hardhat");

async function main() {
    const Faucet = await hre.ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0xD48381c8FfBdaDD263Df063f9B21AFAD1D3Df3e8");

    await faucet.deployed();

    console.log("Faucet Contract deployed: ", faucet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
