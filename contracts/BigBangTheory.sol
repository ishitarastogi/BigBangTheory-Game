// contracts/DungeonsAndDragonsCharacter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

contract BigBangTheory is ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    address public LinkToken;
    uint256 totalCharacters = 4;
    struct BBTCharacterAttributes {
        string name;
        string occupation;
        string lover;
        string university;
        uint256 senseOfHumour;
        uint256 extrovert;
        uint256 socialSkills;
        uint256 sensitive;
        uint256 iq;
    }
    string[4] characterName;
    string[4] characterLovers;
    string[4] characterUniversities;
    string[4] characterOccupation;
    BBTCharacterAttributes[] public characters;
    mapping(bytes32 => address) senderAddress;

    mapping(bytes32 => BBTCharacterAttributes) characterDetails;

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyhash
    )
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("BigBangTheory", "BBT")
    {
        characterName = ["Raj", "Howard", "Leanord", "Sheldon"];
        characterLovers = ["Cinnamon", "Bernadette", "Penny", "Amy"];
        characterUniversities = [
            "Cambridge University",
            "MIT",
            "Princeton University",
            "Caltech"
        ];
        characterOccupation = [
            "AstroPhysics",
            "Aerospace engineer",
            "Experimental Physicist",
            "Theoritical Physicist"
        ];
        VRFCoordinator = _VRFCoordinator;
        LinkToken = _LinkToken;
        keyHash = _keyhash;
        fee = 0.1 * 10**18;
    }

    function requestRandomAttributes() public returns (bytes32) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK ");
        bytes32 requestId = requestRandomness(keyHash, fee);

        senderAddress[requestId] = msg.sender;

        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 newItemId = _tokenIds.current();
        for (uint256 i = 0; i <= characters.length; i++) {
            characterDetails[requestId].name = characterName[i];
             characterDetails[requestId].occupation=characterOccupation[i];
              characterDetails[requestId].lover=characterLovers[i];
               characterDetails[requestId].university=characterUniversities[i];
        }
        uint256 senseOfHumour = uint256(
            keccak256(abi.encode(randomNumber, 1))
        ) % 100;
        uint256 extrovert = uint256(keccak256(abi.encode(randomNumber, 2))) %
            100;
        uint256 SocialSkills = uint256(keccak256(abi.encode(randomNumber, 3))) %
            100;
        uint256 sensitive = uint256(keccak256(abi.encode(randomNumber, 4))) %
            100;
        uint256 iq = uint256(keccak256(abi.encode(randomNumber, 5))) % 100;
        iq=iq+100;
           BBTCharacterAttributes memory character = BBTCharacterAttributes(
      characterDetails[requestId].name,
      characterDetails[requestId].occupation,
      characterDetails[requestId].lover,
      characterDetails[requestId].university,
      senseOfHumour,
      extrovert,
      SocialSkills,
      sensitive,
      iq
    );
    characters.push(character);


        _safeMint(senderAddress[requestId], newItemId);
        _tokenIds.increment();
    }
}
