import { verifyTypedData, recoverTypedDataAddress } from 'viem'
import { account, walletClient } from './config.js'
import { domain, types } from './data.js'
import { ethers } from 'ethers'

async function signAndVerify () {
  try {
    const message = {
      actionType: 'swap',
      asset: 'liquidity_pool',
      tradeType: 'token_swap',
      investment: '500',
      rateOfReturn: '1.05',
      payout: '525',
      transactions: {
        orders: [
          {
            assetHash:
              '0xb77a54b1d439fabf7b9e0b8d9cb89b245a8dfe9b4c7c545f8b1c9c9b4e9d785a',
            tradeToken: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
            totalInvestment: 500,
            allocationPercentage: 100,
            deadline: 1725964155,
            initiator: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
            facilitator: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
            isInitiatorFavoringOutcomeA: false
          }
        ],
        participantSignatures: [
          '0x5ab28cd76f65b5f48e6aace619c9b8d989094ea3a4dbe39278df2851d93443ef545bde188cfabb75ad7efe18037c56628addf383da2d1aee8489fb6a4cdfcc411b'
        ],
        participantContributions: [500]
      }
    }

    // SIGN
    const signature = await walletClient.signTypedData({
      account,
      domain,
      types,
      primaryType: 'TransactionDetails',
      message
    })

    console.log('Signature:', signature)

    const sig = ethers.Signature.from(signature)
    console.log('Parsed Signature:', {
      r: sig.r,
      s: sig.s,
      v: sig.v
    })

    // VERIFY
    const address = await recoverTypedDataAddress({
      address: account.address,
      domain,
      types,
      primaryType: 'TransactionDetails',
      message,
      signature
    })

    console.log('SIGNER:', address)
  } catch (error) {
    console.error('Error in signing or verifying:', error)
  }
}

signAndVerify()
