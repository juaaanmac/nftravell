// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {RewardsToken} from "../src/RewardsToken.sol";

contract DeployRewardsScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("ADMIN_PRIVATE_KEY");
        address callbackSenderAddress = vm.envAddress("REACTIVE_CALLBACK_SENDER");

        vm.startBroadcast(deployerPrivateKey);

        new RewardsToken("Neuquen Rewards Token", "NQNR", 1, callbackSenderAddress);

        vm.stopBroadcast();
    }
}
