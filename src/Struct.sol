// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library Struct {
    /**
     * @dev Represents the details of a transaction, including the action type, asset,
     * trade type, investment, rate of return, payout, and associated transactions.
     * @param actionType The type of action being performed (e.g., "place_bet").
     * @param asset The asset involved in the transaction (e.g., "spreads").
     * @param tradeType The type of trade or bet being placed (e.g., "football").
     * @param investment The amount of investment or stake.
     * @param rateOfReturn The expected rate of return.
     * @param payout The expected payout.
     * @param transactions The group of transactions associated with this detail.
     */
    struct TransactionDetails {
        string actionType;
        string asset;
        string tradeType;
        string investment;
        string rateOfReturn;
        string payout;
        TransactionGroup transactions;
    }

    /**
     * @dev Represents a group of transactions, including orders, participant signatures,
     * and participant contributions.
     * @param orders An array of OrderInfo structs containing details of each order.
     * @param participantSignatures An array of participant signatures for each order.
     * @param participantContributions An array of participant contributions for each order.
     */
    struct TransactionGroup {
        OrderInfo[] orders;
        bytes[] participantSignatures;
        uint256[] participantContributions;
    }

    /**
     * @dev Represents information about an individual order, including asset hash, trade token,
     * total investment, allocation percentage, deadline, initiator, facilitator, and whether
     * the initiator favors a specific outcome.
     * @param assetHash The hash of the asset involved in the order.
     * @param tradeToken The address of the token being traded.
     * @param totalInvestment The total investment made in this order.
     * @param allocationPercentage The percentage of the total investment allocated.
     * @param deadline The deadline for the order.
     * @param initiator The address of the order's initiator.
     * @param facilitator The address of the order's facilitator.
     * @param isInitiatorFavoringOutcomeA Whether the initiator favors outcome A (true) or not (false).
     */
    struct OrderInfo {
        bytes32 assetHash;
        address tradeToken;
        uint256 totalInvestment;
        uint256 allocationPercentage;
        uint256 deadline;
        address initiator;
        address facilitator;
        bool isInitiatorFavoringOutcomeA;
    }

    /// @dev The type hash for the `TransactionDetails` struct used in hashing.
    bytes32 private constant TRANSACTION_DETAILS_TYPEHASH = keccak256(
        "TransactionDetails(string actionType,string asset,string tradeType,string investment,string rateOfReturn,string payout,TransactionGroup transactions)TransactionGroup(OrderInfo[] orders,bytes[] participantSignatures,uint256[] participantContributions)OrderInfo(bytes32 assetHash,address tradeToken,uint256 totalInvestment,uint256 allocationPercentage,uint256 deadline,address initiator,address facilitator,bool isInitiatorFavoringOutcomeA)"
    );

    /// @dev The type hash for the `TransactionGroup` struct used in hashing.
    bytes32 private constant TRANSACTION_GROUP_TYPEHASH = keccak256(
        "TransactionGroup(OrderInfo[] orders,bytes[] participantSignatures,uint256[] participantContributions)OrderInfo(bytes32 assetHash,address tradeToken,uint256 totalInvestment,uint256 allocationPercentage,uint256 deadline,address initiator,address facilitator,bool isInitiatorFavoringOutcomeA)"
    );

    /// @dev The type hash for the `OrderInfo` struct used in hashing.
    bytes32 private constant ORDER_INFO_TYPEHASH = keccak256(
        "OrderInfo(bytes32 assetHash,address tradeToken,uint256 totalInvestment,uint256 allocationPercentage,uint256 deadline,address initiator,address facilitator,bool isInitiatorFavoringOutcomeA)"
    );

    /// @dev Returns the hash of the `OrderInfo`.
    function hashOrderInfo(OrderInfo memory orderInfo) public pure returns (bytes32) {
        return keccak256(
            abi.encode(
                ORDER_INFO_TYPEHASH,
                orderInfo.assetHash,
                orderInfo.tradeToken,
                orderInfo.totalInvestment,
                orderInfo.allocationPercentage,
                orderInfo.deadline,
                orderInfo.initiator,
                orderInfo.facilitator,
                orderInfo.isInitiatorFavoringOutcomeA
            )
        );
    }

    /// @dev Returns the hash of the `OrderInfo` array.
    function hashOrderInfoArray(OrderInfo[] memory orderInfos) public pure returns (bytes32) {
        bytes32[] memory orderInfoBytes = new bytes32[](orderInfos.length);

        for (uint256 i = 0; i < orderInfos.length; i++) {
            orderInfoBytes[i] = hashOrderInfo(orderInfos[i]);
        }

        return keccak256(abi.encodePacked(orderInfoBytes));
    }

    /// @dev Returns the hash of the `participantSignatures` array.
    function hashParticipantSigsArray(bytes[] memory participantSigs) public pure returns (bytes32) {
        bytes32[] memory sigsBytes = new bytes32[](participantSigs.length);

        for (uint256 i = 0; i < participantSigs.length; i++) {
            sigsBytes[i] = keccak256(participantSigs[i]);
        }

        return keccak256(abi.encodePacked(sigsBytes));
    }

    /// @dev Returns the hash of `TransactionGroup` struct.
    function hashTransactionGroup(TransactionGroup memory transactionGroup) public pure returns (bytes32) {
        return keccak256(
            abi.encode(
                TRANSACTION_GROUP_TYPEHASH,
                hashOrderInfoArray(transactionGroup.orders),
                hashParticipantSigsArray(transactionGroup.participantSignatures),
                keccak256(abi.encodePacked(transactionGroup.participantContributions))
            )
        );
    }

    /// @dev Returns the hash of `TransactionDetails` struct.
    function hashTransactionDetails(TransactionDetails memory transactionDetails) public pure returns (bytes32) {
        return keccak256(
            abi.encode(
                TRANSACTION_DETAILS_TYPEHASH,
                keccak256(bytes(transactionDetails.actionType)),
                keccak256(bytes(transactionDetails.asset)),
                keccak256(bytes(transactionDetails.tradeType)),
                keccak256(bytes(transactionDetails.investment)),
                keccak256(bytes(transactionDetails.rateOfReturn)),
                keccak256(bytes(transactionDetails.payout)),
                hashTransactionGroup(transactionDetails.transactions)
            )
        );
    }
}
