// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {PriceFeed} from "./PriceFeed.sol";

contract NFTravell is ERC721, Ownable {
    PriceFeed internal _priceFeed;
    uint256 internal _tokenId;
    uint256 internal _tokenPrice;
    uint256 internal _balance;

    mapping(address => mapping(uint256 => bool)) internal _minted;

    error InvalidValue();
    error IncorrectValue();
    error InvalidAnswer();
    error AlreadyMinted();

    constructor(address priceFeed, uint256 tokenPrice, string memory name, string memory symbol)
        ERC721(name, symbol)
        Ownable(msg.sender)
    {
        require(tokenPrice > 0, "Invalid token price");
        require(priceFeed != address(0), "Invalid PriceFeed address");

        _priceFeed = PriceFeed(priceFeed);
        _tokenPrice = tokenPrice;
    }

    function mint() external payable virtual {
        if (msg.value == 0) {
            revert InvalidValue();
        }

        address sender = _msgSender();
        uint256 currentYear = _currentYear();

        if (_minted[sender][currentYear]) {
            revert AlreadyMinted();
        }

        _checkValue();

        _balance += msg.value;

        _minted[sender][currentYear] = true;

        _mint(sender, ++_tokenId);
    }

    function withdraw() external virtual onlyOwner() {
        payable(owner()).transfer(address(this).balance);
    }

    function _currentYear() internal view returns (uint256) {
        return block.timestamp / 31557600;
    }

    function _checkValue() internal view {
        int256 answer = _priceFeed.getChainlinkDataFeedLatestAnswer();

        if (answer <= 0) {
            revert InvalidAnswer();
        }

        if (msg.value != _tokenPrice * uint256(answer)) {
            revert IncorrectValue();
        }
    }
}
