task("generate-character", "Generate a provably random Chainlink attribute")
    .addParam("contract", "The address of the contract that you want to call")
    .addParam("iq", "The iq of your character")

    .setAction(async taskArgs => {

        const contractAddr = taskArgs.contract
        const networkId = network.name
        console.log("Generating a provably random Chainlink attributes ", contractAddr, " on network ", networkId)
        const bigBangTheory = await ethers.getContractFactory("BigBangTheory")

        //Get signer information
        const accounts = await hre.ethers.getSigners()
        const signer = accounts[1]

        //Create random character
        const bigBangTheoryContract = new ethers.Contract(contractAddr, bigBangTheory.interface, signer)
        const transactionResponse = await bigBangTheoryContract.requestRandomAttributes(taskArgs.iq)
        const transactionReceipt = await transactionResponse.wait()
        console.log('Contract ', contractAddr, ' random character generated. Transaction Hash: ', transactionResponse.hash)
        console.log("npx hardhat create-metadata --contract " + contractAddr + " --network " + network.name)
        const chainId = await getChainId()
        console.log(chainId)

    })

module.exports = {}