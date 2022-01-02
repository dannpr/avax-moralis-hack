task("request-data", "Calls an TwitterValidationConsumer Contract to request external data")
    .addParam("contract", "The address of the TwitterValidationConsumer contract that you want to call")
    .setAction(async taskArgs => {
        const contractAddr = taskArgs.contract
        console.log("Calling TwitterValidationConsumer contract ", contractAddr, " on network ", network.name)
        const TwitterValidationConsumer = await ethers.getContractFactory("TwitterValidationConsumer")

        //Get signer information
        const accounts = await ethers.getSigners()
        const signer = accounts[0]

        //Create connection to API Consumer Contract and call the createRequestTo function
        const twitterValidationConsumer = new ethers.Contract(contractAddr, TwitterValidationConsumer.interface, signer)
        const transaction = await twitterValidationConsumer.requestValidation('1469504391057137664', 'patriciobcs')
        const tx_receipt = await transaction.wait()
        const requestId = tx_receipt.events[0].topics[1]

        //Now check the request
        const request = await twitterValidationConsumer.getRequest(requestId)
        console.log("Request: ", request)

        console.log('Contract ', contractAddr, ' external data request successfully called. Transaction Hash: ', result.hash)
        console.log("Run the following to read the returned result:")
        console.log("npx hardhat read-data --contract " + contractAddr + " --network " + network.name)
    })
module.exports = {}
