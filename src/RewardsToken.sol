// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";

contract RewardsToken is ERC20, Ownable, ERC20Permit, ERC20Votes {
    address internal _callbackSender;
    uint256 internal _tokensPerDay;

    modifier onlyReactive() {
        if (_msgSender() != _callbackSender) {
            revert InvalidCallabackSender(_msgSender());
        }
        _;
    }

    error InvalidCallabackSender(address sender);
    error InvalidTokensPerDay(uint256);

    constructor(string memory name_, string memory symbol_, uint256 tokensPerDay_, address callbackSender_)
        ERC20(name_, symbol_)
        Ownable(_msgSender())
        ERC20Permit(name_)
    {
        _callbackSender = callbackSender_;
        _tokensPerDay = tokensPerDay_;
    }

    function setCallbackSender(address callbackSender) public onlyOwner {
        _callbackSender = callbackSender;
    }

    function setTokensPerDay(uint256 tokensPerDay) public onlyOwner {
        if (tokensPerDay == 0) {
            revert InvalidTokensPerDay(tokensPerDay);
        }
        _tokensPerDay = tokensPerDay;
    }

    function reward(address account) external onlyReactive {
        _mint(account, _rewardAmount());
    }

    function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
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

        return (daysPerYeear - daysElapsed) * _tokensPerDay;
    }
}
