task("generate-character", "Generate a provably random Chainlink attribute")
    .addParam("contract", "The address of the contract that you want to call")
   
    .setAction(async taskArgs => {

        const contractAddr = taskArgs.contract
        const networkId = network.name
        console.log("Generating a provably random Chainlink attributes ", contractAddr, " on network ", networkId)
        const bigBangTheory = await ethers.getContractFactory("BigBangTheory")

        //Get signer information
        const accounts = await hre.ethers.getSigners()
        const signer = accounts[0]

        //Create random character
        const bigBangTheoryContract = new ethers.Contract(contractAddr, bigBangTheory.interface, signer)
        const transactionResponse = await bigBangTheoryContract.requestCharacterAttributes()
        const transactionReceipt = await transactionResponse.wait()
        console.log('Contract ', contractAddr, ' random character generated. Transaction Hash: ', transactionResponse.hash)
        console.log("Run the following to generate the metadata for created characters:")
        console.log("npx hardhat create-metadata --contract " + contractAddr + " --network " + network.name)
        const chainId = await getChainId()
        console.log(chainId)
        /*if(chainId == 31337) {
            const requestId = transactionReceipt.events[3].topics[1]
            const VRFCoordinatorMock = await deployments.get("VRFCoordinatorMock")
            const vrfCoordinatorContract = await ethers.getContractAt("VRFCoordinatorMock", VRFCoordinatorMock.address)
            const fulfillResponse = await vrfCoordinatorContract.callBackWithRandomness(requestId, 777, contractAddr)
            const fulfillReceipt = await fulfillResponse.wait()
            const characters = await dungeonsDragonsContract.characters(0)
            console.log(characters)       
         } */
    })

module.exports = {}