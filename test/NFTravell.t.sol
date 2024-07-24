// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTravell} from "../src/NFTravell.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
import { MockPriceFeed} from "./mocks/MockPriceFeed.sol";

contract NFTravellTest is Test {
    NFTravell public nftravell;
    PriceFeed public priceFeed;
    MockPriceFeed public mockPriceFeed;
    string public name = "NFTravell";
    string public symbol = "NFTV";
    uint256 public tokenPrice = 10;
    int256 public answer = 10000;

    function setUp() public {
        mockPriceFeed = new MockPriceFeed(answer);
        priceFeed = new PriceFeed(address(mockPriceFeed));
        nftravell = new NFTravell(address(priceFeed), tokenPrice, name, symbol);
        vm.warp(1 days * 365 * 2);
    }

    function test_deploy() public view {
        assertEq(nftravell.name(), name);
        assertEq(nftravell.symbol(), symbol);
    }

    function test_mint(address sender) public {
        vm.assume(sender != address(0));
        uint256 value = uint256(answer) * tokenPrice;
        vm.deal(sender, value);
        vm.prank(sender);

        nftravell.mint{value: value}();
        assertEq(nftravell.balanceOf(sender), 1);
    }

    // TODO: add more tests
}
