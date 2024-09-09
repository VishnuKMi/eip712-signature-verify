export const domain = {
  name: 'EIP712-Signatures',
  version: '1',
  chainId: 31337,
  // verifyingContract: '0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC' - If verifying offchain
  verifyingContract: '0x44d10b0f1AdEEA63914313aD3E058D678014DfA5'
}

export const types = {
  TransactionDetails: [
    { name: 'actionType', type: 'string' },
    { name: 'asset', type: 'string' },
    { name: 'tradeType', type: 'string' },
    { name: 'investment', type: 'string' },
    { name: 'rateOfReturn', type: 'string' },
    { name: 'payout', type: 'string' },
    { name: 'transactions', type: 'TransactionGroup' }
  ],
  TransactionGroup: [
    { name: 'orders', type: 'OrderInfo[]' },
    { name: 'participantSignatures', type: 'bytes[]' },
    { name: 'participantContributions', type: 'uint256[]' }
  ],
  OrderInfo: [
    { name: 'assetHash', type: 'bytes32' },
    { name: 'tradeToken', type: 'address' },
    { name: 'totalInvestment', type: 'uint256' },
    { name: 'allocationPercentage', type: 'uint256' },
    { name: 'deadline', type: 'uint256' },
    { name: 'initiator', type: 'address' },
    { name: 'facilitator', type: 'address' },
    { name: 'isInitiatorFavoringOutcomeA', type: 'bool' }
  ]
}
