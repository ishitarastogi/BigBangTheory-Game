// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BuyToken {
    IERC20 public token;
    //1 ETH = 1000 Token
    uint256 public bbtTokensPerEth = 1000;
    event tokenPurchase(address buyer, uint256 amountOfTokens);

    //contract address of BigBangTheory Token
    constructor(IERC20 _token) {
        token = _token;
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
}
