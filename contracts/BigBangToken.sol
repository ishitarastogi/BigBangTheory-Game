// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BigBangToken is ERC20 {
    constructor() ERC20("BigBang Token", "BBTT") {

        _mint(msg.sender, 100 * 10**uint(decimals()));
    }
}
