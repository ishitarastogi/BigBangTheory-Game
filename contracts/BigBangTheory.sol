// contracts/DungeonsAndDragonsCharacter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "hardhat/console.sol";

contract BigBangTheory is ERC721URIStorage, VRFConsumerBase{
 bytes32 internal keyHash;
  uint256 internal fee;
  uint256 public randomResult;
  address public VRFCoordinator;
  address public LinkToken;

    constructor(
    address _VRFCoordinator,
    address _LinkToken,
    bytes32 _keyhash
  )
    public
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("BigBangTheory", "BBT")
  {
    VRFCoordinator = _VRFCoordinator;
    LinkToken = _LinkToken;
    keyHash = _keyhash;
    fee = 0.1 * 10**18; 
  }
   function requestRandomAttributes() public returns (bytes32) {
   require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK ");
        return requestRandomness(keyHash, fee);


  }
  function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
    internal
    override
  {}
}

