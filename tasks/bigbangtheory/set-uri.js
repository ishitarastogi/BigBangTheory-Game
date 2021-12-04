task("set-uri", "Set URI for an NFT")
    .addParam("contract", "The address of the contract that you want to call")
    .addParam("tokenid", "The address of the contract that you want to call")
    .addParam("uri", "URI of NFT")
    .setAction(async taskArgs => {

        const contractAddr = taskArgs.contract
        const networkId = network.name
        console.log("Setting URI for NFTs ", contractAddr, " on network ", networkId)
        const bigBangTheory = await ethers.getContractFactory("BigBangTheory")

        //Get signer information
        const accounts = await hre.ethers.getSigners()
        const signer = accounts[1]

        //Create connection to VRF Contract and call the getRandomNumber function
        const bigBangTheoryContract = new ethers.Contract(contractAddr, bigBangTheory.interface, signer)
        var result = await bigBangTheoryContract.setTokenURI(taskArgs.tokenid,taskArgs.uri)
       
    })

module.exports = {}
