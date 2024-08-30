// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {TGovernor} from "../../src/TGovernor.sol";
import {RewardsTokenHarness} from "../contracts/RewardsTokenHarness.sol";

contract GovernanceTest is Test {
    RewardsTokenHarness public rewardsToken;
    TGovernor public governor;
    uint256 public minDelay = 10;
    address public admin = address(1);
    address public user1 = address(11);
    address public user2 = address(12);
    address public user3 = address(13);
    uint256 initialTokensPerDay = 1;

    function setUp() public {
        vm.startPrank(admin);
        rewardsToken = new RewardsTokenHarness("Tokens", "TKN", initialTokensPerDay, address(20));

        rewardsToken.mint(user1, 5000);
        rewardsToken.mint(user2, 1000);
        rewardsToken.mint(user3, 2000);

        governor = new TGovernor(address(rewardsToken));

        rewardsToken.transferOwnership(address(governor));

        vm.stopPrank();
    }

    function test_ownership() public view {
        assertEq(rewardsToken.owner(), address(governor));
    }

    function test_TokensPerDayChange(uint256 newTokensPerDay) public {
        vm.assume(newTokensPerDay != 0 && newTokensPerDay != initialTokensPerDay && newTokensPerDay < 20);

        // proposal target => rewards token contract
        address[] memory targets = new address[](1);
        targets[0] = address(rewardsToken);

        // no value
        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        // calldata => a call to setTokensPerDay function in target contract
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("setTokensPerDay(uint256)", newTokensPerDay);

        // description
        string memory description = "Proposal #1: Set token per day";

        // delegate votes to the same user
        vm.prank(user1);
        rewardsToken.delegate(user1);

        vm.prank(user2);
        rewardsToken.delegate(user2);

        vm.prank(user3);
        rewardsToken.delegate(user3);

        // create a proposal
        governor.propose(targets, values, calldatas, description);

        // get proposal hash
        uint256 proposalId = governor.hashProposal(targets, values, calldatas, keccak256(bytes(description)));

        // roll time to active the proposal
        vm.roll(governor.proposalSnapshot(proposalId) + 1);

        // user 1 votes for
        vm.prank(user1);
        governor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.For));

        // user 2 votes for
        vm.prank(user2);
        governor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.For));

        // user 3 votes against
        vm.prank(user3);
        governor.castVote(proposalId, uint8(GovernorCountingSimple.VoteType.Against));

        // roll time to success the proposal (beacause quorum is reached)
        vm.roll(governor.proposalDeadline(proposalId) + minDelay);

        // execute the proposal
        governor.execute(targets, values, calldatas, keccak256(bytes(description)));

        assertEq(rewardsToken.rewardsPerDay(), newTokensPerDay);
    }
}
