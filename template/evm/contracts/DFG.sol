//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DwarvesFoudationGem is ERC20 {
    uint256 constant _initial_supply = 100 * (10 ** 18);

    constructor() ERC20("DwarvesFoudationGem", "DFG") {
        _mint(msg.sender, _initial_supply);
    }
}
