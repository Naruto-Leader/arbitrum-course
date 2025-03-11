// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Election, InvalidCandidate, AlreadyVoted} from "../src/Election.sol";

contract ElectionTest is Test {
    Election election;

    function setUp() public {
        string[] memory candidateNames = new string[](2);
        candidateNames[0] = "Ptolomeu";
        candidateNames[1] = "Copernico";
        election = new Election(candidateNames);
    }

    function test_number_of_candidate() public {
        assertEq(election.getCandidateCount(), 2, "Should have 2 Candidates only");
    }

    function test_vote_for_valid_candidate() public {
        election.vote(0);
        (, uint256 voteCount) = election.getCandidate(0);
        assertEq(voteCount, 1, "Vote count for the first candidate should be 1");
    }

    function test_vote_for_invalid_candidate() public {
        uint256 invalidCandidateId = 999;

        vm.expectRevert(InvalidCandidate.selector);
        election.vote(invalidCandidateId);
    }

    function test_single_vote_restriction() public {
        election.vote(0);

        vm.expectRevert(AlreadyVoted.selector);
        election.vote(0);
    }

    function test_get_winner()
        // address addr1,
        // address addr2,
        // address addr3,
        // address addr4
        public
    {
        // vm.assume(addr1 != addr2 && addr1 != addr3 && addr1 != addr4);
        // vm.assume(addr2 != addr3 && addr2 != addr4);
        // vm.assume(addr3 != addr4);

        vm.prank(address(0x1));
        election.vote(0);

        vm.prank(address(0x2));
        election.vote(0);

        vm.prank(address(0x3));
        election.vote(0);

        vm.prank(address(0x4));
        election.vote(1);

        (uint256 id, string memory name) = election.winner();
        assertEq(id, 0, "The winner candidate should be first (0)");
        assertEq(name, "Ptolomeu", "The winner candidate should be first (Ptolomeu)");
    }
}
