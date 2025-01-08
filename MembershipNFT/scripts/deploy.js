const { ethers } = require("hardhat");

async function main() {
    const MembershipNFT = await ethers.getContractFactory("MembershipNFT");
    const membershipNFT = await MembershipNFT.deploy();
    await membershipNFT.deployed();
    console.log("MembershipNFT deployed to:", membershipNFT.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
