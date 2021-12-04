// contracts/DungeonsAndDragonsCharacter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract BigBangTheory is ERC721URIStorage, VRFConsumerBase {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public number = 5;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    address public LinkToken;
    uint256 totalCharacters = 4;
    uint256 private iqP;
    uint256 public b;

    IERC20 public token;
    uint256 public bbtTokensPerEth = 10000;

    //1 ETH = 1000 Token
    event tokenPurchase(address buyer, uint256 amountOfTokens);
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
    event please(uint256, string);
    mapping(bytes32 => BBTCharacterAttributes) characterDetails;

    constructor(
        address _VRFCoordinator,
        address _LinkToken,
        bytes32 _keyhash,
        IERC20 _token
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
        token = _token;
    }

    function requestRandomAttributes(uint _iq)
        public
        returns ( bytes32)
        
    {
                uint256 tokensToPlay = 1 ether / bbtTokensPerEth;

        iqP = _iq;
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK ");
                uint256 allowance = token.allowance(msg.sender, address(this));
    require(allowance >= tokensToPlay, "Check the token allowance");
   token.transferFrom(msg.sender, address(this), tokensToPlay);
        bytes32 requestId = requestRandomness(keyHash, fee);

        senderAddress[requestId] = msg.sender;
        return  requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        uint256 newItemId = _tokenIds.current();
        for (uint256 i = 0; i <= characters.length; i++) {
            characterDetails[requestId].name = characterName[i];
            characterDetails[requestId].occupation = characterOccupation[i];
            characterDetails[requestId].lover = characterLovers[i];
            characterDetails[requestId].university = characterUniversities[i];
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
        iq = iq + 100;
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
        characterDetails[requestId] = character;
        characters.push(character);

        _safeMint(senderAddress[requestId], newItemId);
        _tokenIds.increment();
       guessTheIQ(iqP, requestId);
    }

    function buy() public payable {
        require(msg.value > 0, "value should be greater than zero");
        uint256 tokenToPurchase = msg.value * bbtTokensPerEth;
        //This contract should have enough amount of token to execute the transaction
        uint256 balance = token.balanceOf(address(this));
        require(
            tokenToPurchase <= balance,
            "Not enough tokens in the contract"
        );
        // Transfer token to the msg.sender
        bool sent = token.transfer(msg.sender, tokenToPurchase);
        require(sent, "Token transfer failed");
        emit tokenPurchase(msg.sender, tokenToPurchase);
    }

    function getNumberOfCharacters() public view returns (uint256) {
        return characters.length;
    }

    function guessTheIQ(uint _iq,bytes32 requestId) internal {
        // if (characterDetails[requestId].iq == _iq) {
        //     emit please(_iq, "you won");
        //     b = 4;
        // } else {
        //     emit please(_iq, "you lost");
        //     b = 8;
        // }

        uint256 tokensToPlay = 1 ether / bbtTokensPerEth;
        // require(
        //     token.balanceOf(msg.sender) >= tokensToPlay,
        //     "Your balance is lower than the amount of tokens you want to sell"
        // );
        // bool sent = token.transferFrom(msg.sender, address(this), tokensToPlay);
        // require(sent, "Failed to transfer tokens from user to vendor");
//             uint256 allowance = token.allowance(msg.sender, address(this));
//     require(allowance >= tokensToPlay, "Check the token allowance");
//    token.transferFrom(msg.sender, address(this), tokensToPlay);
        if (
            (_iq <= characterDetails[requestId].iq + 15 &&
                _iq >= characterDetails[requestId].iq) ||
            (_iq >= characterDetails[requestId].iq - 15 &&
                _iq <= characterDetails[requestId].iq)
        ) {
            // if (characterDetails[requestId].iq == _iq) {
            emit please(_iq, "you won");
            b = 4;
            bool sents = token.transfer(msg.sender, tokensToPlay * 2);
            require(sents, "Token transfer failed");
        }  else {
            emit please(_iq, "you lost");
            b = 8;
        }
        
            
        
    }
}

// LINK	0x01BE23585060835E02B77ef475b0Cc51aA1e0709
// VRF Coordinator	0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
// Key Hash	0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
// Fee	0.1 LINK
