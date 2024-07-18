// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script, console2 } from "@forge-std/src/Script.sol";
import "../contracts/DFG.sol";

contract DwavesFoundationGemScript is Script {
    function setUp() public { }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        DwarvesFoudationGem dwavesFoundationGem = new DwarvesFoudationGem();
        vm.stopBroadcast();
        console2.log("DFG address: ", address(dwavesFoundationGem));
    }
}
