// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {EIP712} from "../src/EIP712.sol";
import {MockEIP712} from "./mocks/MockEIP712.sol";
import {console2} from "forge-std/console2.sol";
import {Struct} from "../src/Struct.sol";

contract EIP712Test is Test, EIP712 {
    MockEIP712 mock;

    function setUp() public {
        mock = new MockEIP712();
    }

    function test_domainNameAndVersion() public pure {
        (string memory name, string memory version) = _domainNameAndVersion();

        assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("EIP712-Signatures")));
        assert(keccak256(abi.encodePacked(version)) == keccak256(abi.encodePacked("1")));
    }

    function test_DOMAIN_SEPARATOR() public view {
        bytes32 expectedDomainSeparator = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256("EIP712-Signatures"),
                keccak256("1"),
                block.chainid,
                address(mock)
            )
        );

        assertEq(mock.DOMAIN_SEPARATOR(), expectedDomainSeparator);
        console2.logBytes32(expectedDomainSeparator);
    }

    function test_hashTypedData() public view {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        // Construct OrderInfo struct
        Struct.OrderInfo[] memory orders = new Struct.OrderInfo[](1);
        orders[0] = Struct.OrderInfo({
            assetHash: 0xb77a54b1d439fabf7b9e0b8d9cb89b245a8dfe9b4c7c545f8b1c9c9b4e9d785a,
            tradeToken: address(0x6B175474E89094C44Da98b954EedeAC495271d0F),
            totalInvestment: 500,
            allocationPercentage: 100,
            deadline: 1725964155,
            initiator: address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8),
            facilitator: address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            isInitiatorFavoringOutcomeA: false
        });

        // Construct TransactionGroup struct
        Struct.TransactionGroup memory transactionGroup = Struct.TransactionGroup({
            orders: orders,
            participantSignatures: new bytes[](1),
            participantContributions: new uint256[](1)
        });

        transactionGroup.participantSignatures[0] =
            hex"5ab28cd76f65b5f48e6aace619c9b8d989094ea3a4dbe39278df2851d93443ef545bde188cfabb75ad7efe18037c56628addf383da2d1aee8489fb6a4cdfcc411b";
        transactionGroup.participantContributions[0] = 500;

        // Construct TransactionDetails struct
        Struct.TransactionDetails memory details = Struct.TransactionDetails({
            actionType: "swap",
            asset: "liquidity_pool",
            tradeType: "token_swap",
            investment: "500",
            rateOfReturn: "1.05",
            payout: "525",
            transactions: transactionGroup
        });

        bytes32 structHash = Struct.hashTransactionDetails(details);
        console2.logBytes32(structHash);
        console2.logBytes32(mock.getHashTypedData(structHash));

        bytes32 expectedDigest = keccak256(abi.encodePacked("\x19\x01", mock.getDomainSeparator(), structHash));
        assertEq(mock.getHashTypedData(structHash), expectedDigest);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, expectedDigest);
        address recoveredAddress = ecrecover(expectedDigest, v, r, s);
        console2.log("RECOVERED_ADDRESS", recoveredAddress);
    }
}
