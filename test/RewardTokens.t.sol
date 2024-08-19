// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {RewardsTokenHarness} from "./contracts/RewardsTokenHarness.sol";

contract RewardTokensTest is Test {
    RewardsTokenHarness public rewardsToken;

    string public name = "NFTravell";
    string public symbol = "NFTV";
    uint256 public tokenPrice = 10;
    int256 public answer = 10000;
    address public admin = address(10);
    address public user = address(11);
    address public callbackSender = address(20);

    function setUp() public {
        rewardsToken = new RewardsTokenHarness(name, symbol, callbackSender);
    }

    function test_deploy() public view {
        assertEq(rewardsToken.name(), name);
        assertEq(rewardsToken.symbol(), symbol);
    }

    function test_SetCallbackSender(address newCallbackSender) public {
        rewardsToken.setCallbackSender(newCallbackSender);
    }

    function test_Reward(address account) public {
        vm.assume(account != address(0));
        vm.prank(callbackSender);
        rewardsToken.reward(account);
    }

    function test_RewardRevertsIfCallerIsNotTheCallbackSender(address noCallbackSender) public {
        vm.assume(noCallbackSender != address(0) && noCallbackSender != callbackSender);
        vm.expectRevert(abi.encodeWithSignature("InvalidCallabackSender(address)", noCallbackSender));
        vm.prank(noCallbackSender);
        rewardsToken.reward(user);
    }
}
