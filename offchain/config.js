import { createWalletClient, http } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'
import { polygonAmoy } from 'viem/chains'
import * as dotenv from 'dotenv'
import { resolve, dirname } from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

dotenv.config({ path: resolve(__dirname, '../.env') })

export const walletClient = createWalletClient({
  chain: polygonAmoy,
  transport: http()
})
console.log(process.env.PRIVATE_KEY)
export const account = privateKeyToAccount(process.env.PRIVATE_KEY)
