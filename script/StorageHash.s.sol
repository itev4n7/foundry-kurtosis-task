// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {StorageHash} from "../src/StorageHash.sol";

contract StorageHashScript is Script {
    StorageHash public storageHash;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        storageHash = new StorageHash();
        vm.stopBroadcast();
    }
}
