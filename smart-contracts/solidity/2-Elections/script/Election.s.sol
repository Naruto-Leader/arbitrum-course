// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Election} from "../src/Election.sol";

contract Deploy is Script {
    Election election;

    function run() public {
        vm.startBroadcast();

        string[] memory candidateNames = new string[](2);
        candidateNames[0] = "Candidate1";
        candidateNames[1] = "Candidate2";
        election = new Election(candidateNames);

        console2.log("Election address: ", address(election));

        vm.stopBroadcast();
    }
}
