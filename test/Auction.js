const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Deployment", async function () {
// Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Auction = await ethers.getContractFactory("Auction");
    const auction = await Auction.deploy();
    });