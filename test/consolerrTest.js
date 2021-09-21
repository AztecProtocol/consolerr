const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("consolerr", function () {
  it("testErrorBytes32", async function () {
    const ConsolerrTest = await ethers.getContractFactory("consolerrTest");
    const consolerrTest = await ConsolerrTest.deploy();
    await consolerrTest.deployed();

    await expect(consolerrTest.testErrorBytes32A()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0x00112233445566778899aabbccddeeffffeeddccbbaa99887766554433221100"
    );
    await expect(consolerrTest.testErrorBytes32B()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0x00112233445566778899aabbccddeeffffeeddccbbaa99887766554433221100, 0xffeeddccbbaa9988776655443322110000112233445566778899aabbccddeeff'"
    );
  });

  it("testErrorUint", async function () {
    const ConsolerrTest = await ethers.getContractFactory("consolerrTest");
    const consolerrTest = await ConsolerrTest.deploy();
    await consolerrTest.deployed();

    await expect(consolerrTest.testErrorUintA()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 123456789"
    );
    await expect(consolerrTest.testErrorUintB()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 123456789, 0"
    );
    await expect(consolerrTest.testErrorUintC()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 123456789, 0, 12345678909876543210123456789000998877665544332211584938485102340013249586777"
    );
  });

  it("testErrorAddress", async function () {
    const ConsolerrTest = await ethers.getContractFactory("consolerrTest");
    const consolerrTest = await ConsolerrTest.deploy();
    await consolerrTest.deployed();

    await expect(consolerrTest.testErrorAddressA()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0x00112233445566778899aabbccddeeffffeeddcc"
    );
    await expect(consolerrTest.testErrorAddressB()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0x00112233445566778899aabbccddeeffffeeddcc, 0xffeeddccbbaa9988776655443322110000112233"
    );
    await expect(consolerrTest.testErrorAddressC()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0x00112233445566778899aabbccddeeffffeeddcc, 0xffeeddccbbaa9988776655443322110000112233, 0xffffffffffffffffffffffffffffffffffffffff"
    );
  });

  it("testErrorBytes", async function () {
    const ConsolerrTest = await ethers.getContractFactory("consolerrTest");
    const consolerrTest = await ConsolerrTest.deploy();
    await consolerrTest.deployed();

    await expect(consolerrTest.testErrorBytes()).to.be.revertedWith(
      "reverted with reason string 'consolerr test: 0005070afe"
    );
  });
});
