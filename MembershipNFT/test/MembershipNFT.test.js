const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MembershipNFT", function () {
    it("Should mint a new membership NFT", async function () {
        const [owner] = await ethers.getSigners();
        const MembershipNFT = await ethers.getContractFactory("MembershipNFT");
        const membershipNFT = await MembershipNFT.deploy();
        await membershipNFT.deployed();

        const bronzePrice = ethers.utils.parseEther("0.01");

        await expect(membershipNFT.mintConquerMembership(0, { value: bronzePrice }))
            .to.emit(membershipNFT, "NewMembershipMinted")
            .withArgs(owner.address, 1, 0);

        const balance = await membershipNFT.balanceOf(owner.address);
        expect(balance).to.equal(1);
    });
});
