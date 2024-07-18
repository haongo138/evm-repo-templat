// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../../contracts/upgradeables/DFG.sol";
import "@forge-std/src/Script.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployImplementation is Script {
    function run() external returns (address) {
        address proxy = deployContract();
        return proxy;
    }

    function deployContract() public returns (address) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        DwarvesFoudationGem token = new DwarvesFoudationGem(); // implementation logic

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            DwarvesFoudationGem(token).initialize.selector, "https://app.streamhq.xyz/token/"
        );

        ERC1967Proxy proxy = new ERC1967Proxy(address(token), data); // proxy logic
        vm.stopBroadcast();
        return address(proxy);
    }
}
