// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@forge-std/src/Test.sol";
import "@forge-std/src/Vm.sol";
import "@forge-std/src/console2.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

import "contracts/IcySwap.sol";

// Run the test with command: forge test -vvv
contract StreamPointsTest is Test {
    IcySwap icySwap;

    address internal owner;
    address internal user;
    address internal ICY_ADDRESS;
    address internal USDC_ADDRESS;

    function setUp() public virtual {
        ICY_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        USDC_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        owner = address(0x030c5a);
        user = address(0x030c5a66341c0EDdC771F7aae79ABCA58aDE4c91);
        icySwap = new IcySwap(owner, IERC20(USDC_ADDRESS), IERC20(ICY_ADDRESS), 2 * 10**6);
    }

    function test_swap() public virtual {
        vm.startPrank(user);
        deal(address(ICY_ADDRESS), user, 150 * 10**18);
        deal(address(USDC_ADDRESS), address(icySwap), 150000 * 10**18);
        icySwap.swap(100 * 10**18);
        vm.stopPrank();
        assertEq(icySwap.icy().balanceOf(address(this)), 100 * 10**18, "failed to swap");
    }

    function test_setConversionRate() public virtual {
        vm.prank(owner);
        icySwap.setConversionRate(3 * 10**6);
        assertEq(icySwap.icyToUsdcConversionRate(), 3 * 10**6, "failed to set conversion rate");
    }

    function test_withdrawToOwner() public virtual {
        vm.prank(owner);
        deal(address(USDC_ADDRESS), address(icySwap), 150000 * 10**18);
        icySwap.withdrawToOwner(IERC20(ICY_ADDRESS));
        assertEq(icySwap.icy().balanceOf(address(this)), 0, "failed to withdraw to owner");
    }

    function test_RevertWhen_CallerIsNotOwner() public {
        vm.expectRevert();
        vm.prank(user);
        icySwap.setConversionRate(3 * 10**6); 
    }
}
