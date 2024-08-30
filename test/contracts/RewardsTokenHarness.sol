// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RewardsToken} from "../../src/RewardsToken.sol";

contract RewardsTokenHarness is RewardsToken {
    uint256 public tokensPerDay = 2;

    constructor(string memory name_, string memory symbol_, uint256 tokensPerDay_, address callbackSender_)
        RewardsToken(name_, symbol_, tokensPerDay_, callbackSender_)
    {}

    function callbackSender() public view returns (address) {
        return _callbackSender;
    }

    function rewardsPerDay() public view returns (uint256) {
        return _tokensPerDay;
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}
