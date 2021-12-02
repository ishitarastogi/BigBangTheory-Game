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
        uint128 senseOfHumour;
        uint128 extrovert;
        uint128 socialSkills;
        uint128 sensitive;
        uint256 iq;
    }

    BBTCharacterAttributes[] public characters;
    mapping(bytes32 => address) senderAddress;

    mapping(bytes32 => BBTCharacterAttributes) characterDetails;

    constructor(
        string[4] memory characterName,
        string[4] memory characterLovers,
        string[4] memory characterUniversities,
        string[4] memory characterOccupation,
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

        _safeMint(senderAddress[requestId], newItemId);
        _tokenIds.increment();
    }
}
