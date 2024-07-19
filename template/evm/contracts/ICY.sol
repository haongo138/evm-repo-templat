//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IcyToken is ERC20 {
    uint256 constant _initial_supply = 1000000000 * (10 ** 18);

    constructor() ERC20("IcyToken", "ICY") {
        _mint(msg.sender, _initial_supply);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
