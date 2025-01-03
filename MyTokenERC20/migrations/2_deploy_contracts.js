const MyTokenERC20 = artifacts.require("MyTokenERC20");

module.exports = function (deployer) {
  const maxSupply = web3.utils.toWei('1000000', 'ether'); // Example max supply
  deployer.deploy(MyTokenERC20, maxSupply);
};
