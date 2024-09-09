// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Struct} from "../../src/Struct.sol";
import {EIP712} from "../../src/EIP712.sol";

contract MockEIP712 is EIP712 {
    function getDomainSeparator() external view returns (bytes32) {
        return DOMAIN_SEPARATOR();
    }

    function getHashTypedData(bytes32 structHash) external view returns (bytes32) {
        return _hashTypedData(structHash);
    }
}
