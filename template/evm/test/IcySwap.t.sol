// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@forge-std/src/Test.sol";
import "@forge-std/src/Vm.sol";
import "@forge-std/src/console2.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

import "../contracts/IcySwap.sol";
import "../contracts/ICY.sol";
import "../contracts/USDC.sol";

contract StreamPointsTest is Test {
    IcySwap internal icySwap;
    IcyToken internal icy;
    UsdcToken internal usdc;
    
    address internal user;
    address internal icySwapOwner;
    address internal ICY_ADDRESS;
    address internal USDC_ADDRESS;

    function setUp() public virtual {
        user = address(0x030c5a66341c0EDdC771F7aae79ABCA58aDE4c91);
        icySwapOwner = address(0xAC0eDE69f7CCEe36f0925FbA8E21C5626B5046EC);

        icy = new IcyToken();
        usdc = new UsdcToken();

        vm.startPrank(icySwapOwner);
        icySwap = new IcySwap(
            IERC20(address(usdc)),
            IERC20(address(icy)),
            2 * 10 ** 6
        );
        vm.stopPrank();
    }

    function test_swap() public virtual {
        vm.startPrank(user);
        
        // prepare balance
        icy.mint(user, 150 * 10 ** 18);
        usdc.mint(address(icySwap), 150000 * 10 ** 18);
        icy.approve(address(icySwap), type(uint256).max);
        
        // start swap
        icySwap.swap(100 * 10 ** 18);
        
        vm.stopPrank();
        assertEq(
            icy.balanceOf(address(icySwap)),
            100 * 10 ** 18,
            "failed to swap"
        );
    }

    function test_setConversionRate() public virtual {
        vm.prank(icySwapOwner);
        icySwap.setConversionRate(3 * 10 ** 6);
        assertEq(
            icySwap.icyToUsdcConversionRate(),
            3 * 10 ** 6,
            "failed to set conversion rate"
        );
    }

    function test_withdrawToOwner() public virtual {
        vm.startPrank(icySwapOwner);

        icy.mint(address(icySwap), 150 * 10 ** 18);
        icySwap.withdrawToOwner(icy);

        vm.stopPrank();
        assertEq(
            icySwap.icy().balanceOf(address(icySwap)),
            0,
            "failed to withdraw to owner"
        );
    }

    function test_RevertWhen_CallerIsNotOwner() public {
        vm.expectRevert();
        vm.prank(user);
        icySwap.setConversionRate(3 * 10 ** 6);
    }
}
