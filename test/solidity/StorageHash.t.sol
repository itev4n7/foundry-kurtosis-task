// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StorageHash} from "../../src/StorageHash.sol";

contract StorageHashTest is Test {
    uint256 kurtosisFork;
    StorageHash public storageHash;

    function setUp() public {
        string memory rpcUrl = vm.envString("RPC_URL");
        kurtosisFork = vm.createFork(rpcUrl);
        vm.selectFork(kurtosisFork);
        storageHash = new StorageHash();
    }

    function testInitialValueIsZero() public view {
        assertEq(storageHash.hashedValue(), bytes32(0));
    }

    function testHashNumber() public {
        uint256 numberValue = 55;
        bytes32 expectedHash = sha256(abi.encodePacked(numberValue));
        storageHash.hashNumber(numberValue);
        assertEq(storageHash.hashedValue(), expectedHash);
    }

    function testHashNumberWithStringShouldFail() public {
        bytes memory payload = abi.encodeWithSignature("hashNumber(string)", "55");

        (bool success,) = address(storageHash).call(payload);
        assertFalse(success, "Call should fail when passing a string to setNumber(uint256)");
    }

    function testFuzzHashNumber(uint256 x) public {
        bytes32 expectedHash = sha256(abi.encodePacked(x));
        storageHash.hashNumber(x);
        assertEq(storageHash.hashedValue(), expectedHash, "Hashed value mismatch");
    }
}
