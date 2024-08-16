// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RewardsToken is ERC20, Ownable {
    uint256 internal _rewardAmount = 100;
    address internal _callbackSender;

    modifier onlyReactive() {
        if (_msgSender() != _callbackSender ) {
            revert InvalidCallabackSender(_msgSender());
        }
        _;
    }

    error InvalidCallabackSender(address sender);

    constructor(string memory name_, string memory symbol_, address callbackSender_)
        ERC20(name_,symbol_)
        Ownable(_msgSender())
    {
        _callbackSender = callbackSender_;
    }

    function reward(address account) external onlyReactive() {
        _mint(account, _rewardAmount);
    }
}
