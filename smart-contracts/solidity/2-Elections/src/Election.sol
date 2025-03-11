// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

error AlreadyVoted();
error InvalidCandidate();

contract Election {
    event Voted(address indexed voter, uint256 indexed candidateId);
    event CandidateAdded(uint256 indexed candidateId, string name);

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    mapping(address => bool) public hasVoted;
    Candidate[] public candidates;

    modifier validCandidate(uint256 candidateId) {
        if (candidateId >= candidates.length) {
            revert InvalidCandidate();
        }
        _;
    }

    modifier notVoted() {
        if (hasVoted[msg.sender]) {
            revert AlreadyVoted();
        }
        _;
    }

    constructor(string[] memory candidateNames) {
        for (uint256 i = 0; i < candidateNames.length; i++) {
            Candidate memory candidate = Candidate(candidateNames[i], 0);

            candidates.push(candidate);
            emit CandidateAdded(i, candidateNames[i]);
        }
    }

    function vote(uint256 candidateId) external validCandidate(candidateId) notVoted {
        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount++;
        emit Voted(msg.sender, candidateId);
    }

    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    function getCandidate(uint256 candidateId)
        external
        view
        validCandidate(candidateId)
        returns (string memory, uint256)
    {
        Candidate memory candidate = candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }

    function addCandidate(string memory name) external {
        Candidate memory candidate = Candidate(name, 0);

        candidates.push(candidate);

        emit CandidateAdded(candidates.length - 1, name);
    }

    function winner() external view returns (uint256, string memory) {
        uint256 maxVote = 0;
        uint256 winnerId = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVote) {
                maxVote = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return (winnerId, candidates[winnerId].name);
    }
}
