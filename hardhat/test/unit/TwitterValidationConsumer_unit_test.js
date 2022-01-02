const { networkConfig, autoFundCheck, developmentChains } = require('../../helper-hardhat-config')
const skipIf = require('mocha-skip-if')
const chai = require('chai')
const { expect } = require('chai')
const BN = require('bn.js')
const { getChainId } = require('hardhat')
chai.use(require('chai-bn')(BN))

skip.if(!developmentChains.includes(network.name)).
  describe('TwitterValidationConsumer Unit Tests', async function () {

    let twitterValidationConsumer, linkToken

    beforeEach(async () => {
      const chainId = await getChainId()
      await deployments.fixture(['mocks', 'api'])
      const LinkToken = await deployments.get('LinkToken')
      linkToken = await ethers.getContractAt('LinkToken', LinkToken.address)
      const networkName = networkConfig[chainId]['name']

      linkTokenAddress = linkToken.address
      additionalMessage = " --linkaddress " + linkTokenAddress

      const TwitterValidationConsumer = await deployments.get('TwitterValidationConsumer')
      twitterValidationConsumer = await ethers.getContractAt('TwitterValidationConsumer', TwitterValidationConsumer.address)

      if (await autoFundCheck(twitterValidationConsumer.address, networkName, linkTokenAddress, additionalMessage)) {
        await hre.run("fund-link", { contract: twitterValidationConsumer.address, linkaddress: linkTokenAddress })
      }
    })

    it('Should successfully make an API request', async () => {
      const transaction = await twitterValidationConsumer.requestValidation('1469504391057137664', 'patriciobcs') 
      const tx_receipt = await transaction.wait()
      const requestId = tx_receipt.events[0].topics[1]

      console.log("RequestID:", requestId);

      //Now check the result
      const request = await twitterValidationConsumer.getRequest(requestId)
      console.log("Request: ", request)

      console.log("requestId: ", requestId)
      expect(requestId).to.not.be.null
    })
  })
