// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PriceFeed} from "../src/PriceFeed.sol";
import {NFTravell} from "../src/NFTravell.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("ADMIN_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address priceFeedAddress = vm.envAddress("PRICE_FEED");
        PriceFeed priceFeed = new PriceFeed(priceFeedAddress);

        new NFTravell(address(priceFeed), 2, "Villa la Angostura Token", "VLAT");

        vm.stopBroadcast();
    }
}
