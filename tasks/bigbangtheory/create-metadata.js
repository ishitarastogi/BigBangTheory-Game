
const fs = require('fs')
require("@nomiclabs/hardhat-web3");

task("create-metadata", "Create metadata for all created characters")
    .addParam("contract", "The address of the contract that you want to call")
    .setAction(async taskArgs => {

    const contractAddr = taskArgs.contract

    //Get signer information
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[1]

const metadataTemple = {
    "name": "",
    "occupation":"",
    "lover":"",
    "university":"",
    "description": "",
    "image": "",
    "attributes": [
        {
            "trait_type": "senseOfHumour",
            "value": 0
        },
        {
            "trait_type": "extrovert",
            "value": 0
        },
     
        {
            "trait_type": "socialSkills",
            "value": 0
        },
        {
            "trait_type": "sensitive",
            "value": 0
        },  
         {
            "trait_type": "iq",
            "value": 0
        }
    ]
}
    const bigBangTheory = await ethers.getContractAt('BigBangTheory', contractAddr)
    length = await bigBangTheory.getNumberOfCharacters()
    index = 0
    while (index < length) {
        console.log('Let\'s get the overview of your character ' + index + ' of ' + length)
        let characterMetadata = metadataTemple
        let characterOverview = await bigBangTheory.characters(index)
        index++
        characterMetadata['name'] = characterOverview['name']
        characterMetadata['occupation'] = characterOverview['occupation']
        characterMetadata['lover'] = characterOverview['lover']
        characterMetadata['university'] = characterOverview['university']

        if (fs.existsSync('metadata/' + characterMetadata['name'].toLowerCase().replace(/\s/g, '-') + '.json')) {
            console.log('test')
            continue
        }
        console.log(characterMetadata['name'])
        characterMetadata['attributes'][0]['value'] = characterOverview['senseOfHumour'].toNumber()
        characterMetadata['attributes'][1]['value'] = characterOverview['extrovert'].toNumber()
        characterMetadata['attributes'][2]['value'] = characterOverview['socialSkills'].toNumber()
        characterMetadata['attributes'][3]['value'] = characterOverview['sensitive'].toNumber()
        characterMetadata['attributes'][4]['value'] = characterOverview['iq'].toNumber()

 
        filename = 'metadata/' + characterMetadata['name'].toLowerCase().replace(/\s/g, '-')
        let data = JSON.stringify(characterMetadata)
        fs.writeFileSync(filename + '.mjs', data)
        console.log("npx hardhat set-uri --contract " + contractAddr + " --tokenid InsertIdHere" + " --uri insertURIHere" + " --network " + network.name)
    }
})


module.exports = {}
