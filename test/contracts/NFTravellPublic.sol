// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {NFTravell} from "../../src/NFTravell.sol";

contract NFTravellPublic is NFTravell {
    constructor(address _priceFeed, uint256 _tokenPrice, string memory _name, string memory _symbol)
        NFTravell(_priceFeed, _tokenPrice, _name, _symbol)
    {}

    function tokenPrice() public view returns (uint256) {
        return _tokenPrice;
    }

    function balance() public view returns (uint256) {
        return _balance;
    }

    function tokenId() public view returns (uint256) {
        return _tokenId;
    }

    function currentYear() public view returns (uint256) {
        return _currentYear();
    }
}
