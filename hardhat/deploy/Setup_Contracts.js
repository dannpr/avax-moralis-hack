const { networkConfig, autoFundCheck } = require('../helper-hardhat-config')
const { ethers } = require('hardhat')

module.exports = async ({
  getNamedAccounts,
  deployments
}) => {
  const { log } = deployments
  const chainId = await getChainId()
  let linkTokenAddress
  let additionalMessage = ""
  //set log level to ignore non errors
  ethers.utils.Logger.setLogLevel(ethers.utils.Logger.levels.ERROR)
  const networkName = networkConfig[chainId]['name']

  linkTokenAddress = networkConfig[chainId]['linkToken']
  oracle = networkConfig[chainId]['oracle']

  //Try Auto-fund TwitterValidationConsumer contract with LINK
  const TwitterValidationConsumer = await deployments.get('TwitterValidationConsumer')
  const twitterValidationConsumer = await ethers.getContractAt('TwitterValidationConsumer', TwitterValidationConsumer.address)

  if (await autoFundCheck(twitterValidationConsumer.address, networkName, linkTokenAddress, additionalMessage)) {
    await hre.run("fund-link", { contract: twitterValidationConsumer.address, linkaddress: linkTokenAddress })
  } else {
    log("Then run TwitterValidationConsumer contract with following command:")
    log("npx hardhat request-data --contract " + twitterValidationConsumer.address + " --network " + networkName)
  }
  log("----------------------------------------------------")
}
module.exports.tags = ['all']
