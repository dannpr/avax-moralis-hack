const chai = require('chai')
const { expect } = require('chai')
const BN = require('bn.js')
chai.use(require('chai-bn')(BN))
const skipIf = require('mocha-skip-if')
const { developmentChains } = require('../../helper-hardhat-config')

skip.if(developmentChains.includes(network.name)).
  describe('TwitterValidationConsumer Integration Tests', async function () {

    let twitterValidationConsumer

    beforeEach(async () => {
      const TwitterValidationConsumer = await deployments.get('TwitterValidationConsumer')
      twitterValidationConsumer = await ethers.getContractAt('TwitterValidationConsumer', TwitterValidationConsumer.address)
    })

    it('Should successfully make an external API request and get a result', async () => {
      const transaction = await twitterValidationConsumer.requestValidation('1469504391057137664', 'patriciobcs')
      const tx_receipt = await transaction.wait()
      const requestId = tx_receipt.events[0].topics[1]
      console.log("RequestID:", requestId);

      //Now check the result
      const request = await twitterValidationConsumer.getRequest(requestId)
      console.log("Request: ", request)

      //wait 15 secs for oracle to callback
      await new Promise(resolve => setTimeout(resolve, 15000))

      //Now check the result
      const result = await twitterValidationConsumer.getAddress('patriciobcs')
      console.log("TwitterValidationConsumer Address: ", result)
    })
  })
