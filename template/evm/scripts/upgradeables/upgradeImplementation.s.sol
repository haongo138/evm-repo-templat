// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@forge-std/src/Script.sol";
import { DwarvesFoudationGem } from "../../contracts/upgradeables/DFG.sol";
import { DwarvesFoudationGemV2 } from "../../contracts/upgradeables/DFGv2.sol";

contract UpgradeImplementation is Script {
    function run() external returns (address) {
        address PROXY_ADDRESS = address(0xAd9810cDFfF79E69b8a8Ae973D39d48B3eC90b7E); // REPLACE WITH YOUR DEPLOYED PROXY ADDRESS
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        DwarvesFoudationGemV2 v2 = new DwarvesFoudationGemV2();
        vm.stopBroadcast();

        address proxy = upgradeContractImplementation(PROXY_ADDRESS, address(v2));
        return proxy;
    }

    function upgradeContractImplementation(address proxy, address newContract)
        public
        returns (address)
    {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        DwarvesFoudationGem v1Proxy = DwarvesFoudationGem(proxy);

        v1Proxy.upgradeToAndCall(address(newContract), new bytes(0)); // point the proxy to the new implementation
        vm.stopBroadcast();
        return address(v1Proxy);
    }
}
