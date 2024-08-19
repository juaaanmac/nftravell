// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTravellPublic} from "./contracts/NFTravellPublic.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
import {INFTravellErrors} from "../src/interfaces/INFTravellErrors.sol";
import {MockPriceFeed} from "./mocks/MockPriceFeed.sol";

contract NFTravellTest is Test {
    NFTravellPublic public nftravell;
    PriceFeed public priceFeed;
    MockPriceFeed public mockPriceFeed;
    string public name = "NFTravell";
    string public symbol = "NFTV";
    uint256 public tokenPrice = 10;
    int256 public answer = 10000;
    address public admin = address(10);
    address public user = address(11);

    event TokenMinted(address indexed user, uint256 indexed year, uint256 tokenId);
    event Withdrawn(uint256 indexed amount);

    function setUp() public {
        mockPriceFeed = new MockPriceFeed(answer);
        priceFeed = new PriceFeed(address(mockPriceFeed));
        vm.prank(admin);
        nftravell = new NFTravellPublic(address(priceFeed), tokenPrice, name, symbol);
        vm.warp(1 days * 365 * 2);
    }

    function test_deploy() public view {
        assertEq(nftravell.name(), name);
        assertEq(nftravell.symbol(), symbol);
        assertEq(nftravell.tokenPrice(), tokenPrice);
    }

    function test_deployRevertsIfTokenPriceIsInvalid() public {
        uint256 invalidTokenPrice = 0;
        vm.expectRevert("Invalid token price");
        new NFTravellPublic(address(priceFeed), invalidTokenPrice, name, symbol);
    }

    function test_deployRevertsIfPriceFeedIsInvalid() public {
        address invalidPriceFeed = address(0);
        vm.expectRevert("Invalid PriceFeed address");
        new NFTravellPublic(invalidPriceFeed, tokenPrice, name, symbol);
    }

    function test_Mint(address sender) public {
        vm.assume(sender != address(0));
        uint256 value = _value();
        vm.deal(sender, value);
        vm.prank(sender);

        nftravell.mint{value: value}();
        assertEq(nftravell.balanceOf(sender), 1, "balance of sender should be 1");
        assertEq(nftravell.ownerOf(1), sender, "owner of token 1 should be sender");
        assertEq(nftravell.tokenId(), 1, "token id should be 1");
        assertEq(nftravell.balance(), value, "balance should be `value`");
    }

    function test_MintRevertsIfValueIsZero() public {
        vm.expectRevert(INFTravellErrors.InvalidValue.selector);
        nftravell.mint{value: 0}();
    }

    function test_MintRevertsIfTokenIsMinted() public {
        nftravell.mint{value: _value()}();
        vm.expectRevert(INFTravellErrors.AlreadyMinted.selector);
        nftravell.mint{value: _value()}();
    }

    function test_MintRevertsIfValueIsIncorrect() public {
        vm.expectRevert(INFTravellErrors.IncorrectValue.selector);
        nftravell.mint{value: _value() + 1}();
    }

    function test_MintRevertsIfUserWantsToTransfer() public {
        nftravell.mint{value: _value()}();
        vm.expectRevert(INFTravellErrors.NotAllowedOperation.selector);
        nftravell.transferFrom(address(nftravell), address(10), 1);
    }

    function test_MintEmitsEvent() public {
        uint256 value = _value();
        vm.expectEmit(true, true, true, true);
        emit TokenMinted(user, nftravell.currentYear(), 1);

        vm.deal(user, value);
        vm.prank(user);
        nftravell.mint{value: value}();
    }

    function test_Withdraw() public {
        uint256 value = _value();
        vm.deal(user, value);
        vm.prank(user);
        nftravell.mint{value: value}();

        vm.prank(admin);
        nftravell.withdraw();

        assertEq(admin.balance, value);
    }

    function test_WithdrawRevertsIfCallerIsNotTheAdmin(address noAdmin) public {
        vm.assume(noAdmin != address(0) && noAdmin != admin);
        uint256 value = _value();
        vm.deal(user, value);
        vm.prank(user);
        nftravell.mint{value: value}();

        vm.prank(noAdmin);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", noAdmin));
        nftravell.withdraw();
    }

    function test_WithdrawEmitsEvent() public {
        uint256 value = _value();
        vm.deal(user, value);
        vm.prank(user);
        nftravell.mint{value: value}();

        vm.expectEmit(true, true, false, false);
        emit Withdrawn(value);
        vm.prank(admin);
        nftravell.withdraw();
    }

    function _value() internal view returns (uint256) {
        return uint256(answer) * tokenPrice;
    }
}
