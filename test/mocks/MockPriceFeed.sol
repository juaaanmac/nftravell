// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract MockPriceFeed is AggregatorV3Interface {
    uint80 private roundId;
    int256 private answer;
    uint256 private startedAt;
    uint256 private updatedAt;
    uint80 private answeredInRound;

    constructor(int256 answer_) {
        roundId = 0;
        answer = answer_;
        startedAt = block.timestamp;
        updatedAt = block.timestamp;
        answeredInRound = 0;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function description() external pure override returns (string memory) {
        return "mock data feed";
    }

    function version() external pure override returns (uint256) {
        return 1;
    }

    function getRoundData(uint80) external view override returns (uint80, int256, uint256, uint256, uint80) {
        return (roundId, answer, block.timestamp, block.timestamp, answeredInRound);
    }

    function latestRoundData() external view override returns (uint80, int256, uint256, uint256, uint80) {
        return (roundId, answer, block.timestamp, block.timestamp, answeredInRound);
    }
}
