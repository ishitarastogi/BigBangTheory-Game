let {networkConfig} = require('../helper-hardhat-config')

module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId
}) => {

  const { deploy, get, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = await getChainId()
  let linkTokenAddress
  let vrfCoordinatorAddress
  let additionalMessage = ""
  if (chainId == 31337) {
    linkToken = await get('LinkToken')
    VRFCoordinatorMock = await get('VRFCoordinatorMock')
    linkTokenAddress = linkToken.address
    vrfCoordinatorAddress = VRFCoordinatorMock.address
    additionalMessage = " --linkaddress " + linkTokenAddress
   
  } else {
    linkTokenAddress = networkConfig[chainId]['linkToken']
    vrfCoordinatorAddress = networkConfig[chainId]['vrfCoordinator']
  }
  const keyHash = networkConfig[chainId]['keyHash']
  const fee = networkConfig[chainId]['fee']
  // const bigBangToken = await deploy('BigBangToken', {
  //   from: deployer,
  // })

  const bigBangTheory = await deploy('BigBangTheory', {
    from: deployer,
    args: [vrfCoordinatorAddress, linkTokenAddress, keyHash,bigBangToken.address], 
    log: true
  })
  
  log("npx hardhat fund-link --contract " + bigBangTheory.address + " --network " + networkConfig[chainId]['name'] + additionalMessage)
  log("To generate a character run the following:")
  log("npx hardhat generate-character --contract " + bigBangTheory.address + " --name InsertNameHere " +  " --network " + networkConfig[chainId]['name'])
  log("To get a character's details as metadata run the following:")
  log("npx hardhat create-metadata --contract " + bigBangTheory.address + " --network " + networkConfig[chainId]['name'])
}

module.exports.tags = ['all', 'D&D']