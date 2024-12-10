const { expect } = require("chai");

describe("VendingMachine", function () {
    it("Should set the owner on deployment", async function () {
        const [owner] = await ethers.getSigners();
        const VendingMachine = await ethers.getContractFactory("VendingMachine");
        const vendingMachine = await VendingMachine.deploy();
        await vendingMachine.deployed();

        expect(await vendingMachine.owner()).to.equal(owner.address);
    });

    it("Should allow the owner to add a product", async function () {
        const VendingMachine = await ethers.getContractFactory("VendingMachine");
        const vendingMachine = await VendingMachine.deploy();
        await vendingMachine.deployed();

        await vendingMachine.addProduct("Soda", ethers.utils.parseEther("0.1"), 10);
        const stock = await vendingMachine.productStock("Soda");
        expect(stock).to.equal(10);
    });
});
