task("read-data", "Calls an TwitterValidationConsumer Contract to read data obtained from an external API")
    .addParam("contract", "The address of the TwitterValidationConsumer contract that you want to call")
    .setAction(async taskArgs => {
        const contractAddr = taskArgs.contract
        const networkId = network.name
        console.log("Reading data from TwitterValidationConsumer contract ", contractAddr, " on network ", networkId)
        const TwitterValidationConsumer = await ethers.getContractFactory("TwitterValidationConsumer")

        //Get signer information
        const accounts = await ethers.getSigners()
        const signer = accounts[0]

        //Create connection to API Consumer Contract and call the createRequestTo function
        const twitterValidationConsumer = new ethers.Contract(contractAddr, TwitterValidationConsumer.interface, signer)
        
        let result = await twitterValidationConsumer.getAddress('patriciobcs')
        console.log('Address is: ', result)


        if (result == undefined && ['hardhat', 'localhost', 'ganache'].indexOf(network.name) == 0) {
            console.log("You'll either need to wait another minute, or fix something!")
        }
        if (['hardhat', 'localhost', 'ganache'].indexOf(network.name) >= 0) {
            console.log("You'll have to manually update the value since you're on a local chain!")
        }
    })

module.exports = {}
