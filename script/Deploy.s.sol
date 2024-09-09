// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseScript} from "./utils/Base.s.sol";
import {console} from "forge-std/Script.sol";
import {EIP712} from "../src/EIP712.sol";

contract Deploy is BaseScript {
    function run() public broadcast returns (EIP712 eip) {
        eip = new EIP712();
        console.log("EIP712 deployed at:", address(eip));
    }
}
