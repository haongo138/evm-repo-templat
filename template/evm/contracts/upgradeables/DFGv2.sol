//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.24;

import "@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import { UUPSUpgradeable } from
    "@openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";

contract DwarvesFoudationGemV2 is ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    string constant VERSION = "1.0.1";
    uint256 constant _initial_supply = 100 * (10 ** 18);

    function initialize() external initializer {
        __ERC20_init("DwarvesFoudationGem", "DFG");
        __UUPSUpgradeable_init();
        __Ownable_init(msg.sender);
        _mint(msg.sender, _initial_supply);
    }

    function getVersion() public pure returns (string memory) {
        return VERSION;
    }

    function _authorizeUpgrade(address) internal override onlyOwner { }
}
