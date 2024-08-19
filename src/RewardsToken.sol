// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RewardsToken is ERC20, Ownable {
    address private _callbackSender;

    modifier onlyReactive() {
        if (_msgSender() != _callbackSender) {
            revert InvalidCallabackSender(_msgSender());
        }
        _;
    }

    error InvalidCallabackSender(address sender);

    constructor(string memory name_, string memory symbol_, address callbackSender_)
        ERC20(name_, symbol_)
        Ownable(_msgSender())
    {
        _callbackSender = callbackSender_;
    }

    function setCallbackSender(address callbackSender) public onlyOwner {
        _callbackSender = callbackSender;
    }

    function reward(address account) external onlyReactive {
        _mint(account, _rewardAmount());
    }

    function _rewardAmount() internal view returns (uint256) {
        uint256 secondsPerDay = 60 * 60 * 24;
        uint256 secondsPerYear = 31557600; // 60 * 60 * 24 * 365.25
        uint256 daysPerYeear = 365;

        /**
         * by doing the division before the multiplication, I get the timestamp of the first day
         * of the current year and then I get the number of seconds elapsed until that day
         */
        uint256 dias = (block.timestamp / secondsPerYear) * secondsPerYear;

        // get the number of days elapsed since the first day of the current year
        uint256 daysElapsed = (block.timestamp - dias) / secondsPerDay + 1;

        return daysPerYeear - daysElapsed;
    }
}
