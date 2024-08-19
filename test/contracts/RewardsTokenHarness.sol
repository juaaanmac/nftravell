// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RewardsToken} from "../../src/RewardsToken.sol";

contract RewardsTokenHarness is RewardsToken {
    constructor(string memory name_, string memory symbol_, address callbackSender_)
        RewardsToken(name_, symbol_, callbackSender_)
    {}

    function callbackSender() public view returns (address) {
        return _callbackSender;
    }
}
