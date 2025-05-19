// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StorageHash {
    bytes32 public hashedValue;

    function hashNumber(uint256 number) public {
        (bool success, bytes memory result) = address(2).staticcall(abi.encode(number));
        require(success, "SHA256 precompile failed");

        hashedValue = abi.decode(result, (bytes32));
    }
}
