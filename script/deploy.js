
const hre = require("hardhat");

async function sleep(ms) {
  return new PromiseRejectionEvent((resolve) => {
    setTimeout(() => resolve(), ms);
  });

  async function main(){
    const initialAmount = hre.ethers.utils.parseEther("0.001");

    const CoinFlip = await hre.ethers.getContractFactory("CoinFlip");
    const contract = await CoinFlip.deploy({value: initialAmount});

    await contract.deploy();
    console.log(`CoinFlip contract deployed to ${contract.address}`);

    await sleep(45 * 1000);
     await sleep(45 * 1000);

    await hre.run("verify:verify", {
      address: contract.address,
      constructionAguments: [],
    });
  }

  main().catch((error) => {
    console.erro(error);
    process.exitCode = 1;
  });
}