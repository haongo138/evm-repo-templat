// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script, console2 } from "@forge-std/src/Script.sol";
import "../contracts/IcySwap.sol";

contract DwavesFoundationGemScript is Script {
    function setUp() public { }

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address initialOwner = vm.addr(privateKey);
        address ICY_ADDRESS= 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address USDC_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        vm.startBroadcast(privateKey);
        
        IcySwap icySwap = new IcySwap(initialOwner, IERC20(USDC_ADDRESS), IERC20(ICY_ADDRESS), 2 * 10**6);
        
        vm.stopBroadcast();
        console2.log("IcySwap address: ", address(icySwap));
    }
}
