const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Marketplace", async function () {
    const NftXts = await ethers.getContractFactory("NftXts");
    const nftXts = await NftXts.deploy();

    const nft1 = await nftXts.mint(1);

    const feePercent = 10;

// Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Marketplace = await ethers.getContractFactory("NFtMarketplaceXts");
    const marketplace = await Marketplace.deploy(feePercent);

        return { marketplace, feePercent, owner, otherAccount };
    });


describe("Deployment", function () {
    it("sss", async function () {
    const NftXts = await ethers.getContractFactory("NftXts");
    const nftXts = await NftXts.deploy();

    const feePercent = 10;
    const [owner, otherAccount] = await ethers.getSigners();
    const Marketplace = await ethers.getContractFactory("NFtMarketplaceXts");
    const marketplace = await Marketplace.deploy(feePercent);

    //await nftXts.setApprovalForAll(owner.address, 1)
    const sss = await nftXts.mint("test", {from: owner.address});
    await marketplace.listItem(nftXts.address, 1, 10, {from: sss.address});

      });
});