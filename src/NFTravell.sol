// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {PriceFeed} from "./PriceFeed.sol";
import {INFTravellErrors} from "./interfaces/INFTravellErrors.sol";

contract NFTravell is ERC721, Ownable, INFTravellErrors {
    uint256 internal _tokenId;
    uint256 internal _tokenPrice;
    uint256 internal _balance;
    PriceFeed internal _priceFeed;

    mapping(address => mapping(uint256 => bool)) internal _minted;

    event TokenMinted(address indexed user, uint256 indexed year, uint256 indexed tokenId);
    event Withdrawn(uint256 indexed amount);

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
            revert INFTravellErrors.InvalidValue();
        }

        address sender = _msgSender();
        uint256 currentYear = _currentYear();

        if (_minted[sender][currentYear]) {
            revert INFTravellErrors.AlreadyMinted();
        }

        _checkValue();

        _balance += msg.value;

        _minted[sender][currentYear] = true;

        _mint(sender, ++_tokenId);

        emit TokenMinted(sender, currentYear, _tokenId);
    }

    function withdraw() external virtual onlyOwner {
        payable(owner()).transfer(_balance);

        _balance = 0;

        emit Withdrawn(_balance);
    }

    function _currentYear() internal view returns (uint256) {
        return block.timestamp / 31557600;
    }

    function _checkValue() internal view {
        int256 answer = _priceFeed.getChainlinkDataFeedLatestAnswer();

        if (answer <= 0) {
            revert INFTravellErrors.InvalidPrice();
        }

        if (msg.value != _tokenPrice * uint256(answer)) {
            revert INFTravellErrors.IncorrectValue();
        }
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        virtual
        override
        returns (address previousOwner)
    {
        previousOwner = super._update(to, tokenId, auth);

        if (previousOwner != address(0)) {
            revert INFTravellErrors.NotAllowedOperation();
        }
    }
}
