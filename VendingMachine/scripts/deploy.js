const hre = require("hardhat");

async function main() {
    const VendingMachine = await hre.ethers.getContractFactory("VendingMachine");
    const vendingMachine = await VendingMachine.deploy();

    await vendingMachine.deployed();

    console.log("VendingMachine deployed to:", vendingMachine.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
