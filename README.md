# EIP-712 Signatures Demo

A minimal reproduction demonstrating the signing and verification of complex data structures using EIP-712 signatures, both off-chain and on-chain.

## Introduction to EIP-712

EIP-712 was a game-changer in Ethereum's data handling, much like email transforming communication. Before EIP-712, signing data on Ethereum was like trying to read a book in the dark - possible, but difficult and prone to errors.

### What is EIP-712?

EIP-712 introduced a way to sign and hash typed structured data, making data on Ethereum as clear and understandable as a well-organized book.

### Key Features

- **Typed Structured Data**: Think of this as moving from vague text messages to clear, detailed emails.
- **Safe Hashing Algorithm**: Ensures data integrity, similar to a tamper-proof document seal.
- **Domain Separation**: This is like having a unique postmark for different letters, ensuring they don't get mixed up.

### Goals of EIP-712

EIP-712 aimed to make off-chain message signing clearer and safer, like ensuring signatures on paper are accurately reflected in the digital world.

### Problem-Solving

Originally, users faced confusing hex strings, akin to signing a contract in a foreign language. EIP-712 solved this by bringing clarity and context to data, like a translator making a foreign contract understandable.

## Setup

1. Clone the repository:

   ```
   git clone https://github.com/VishnuKMi/eip712-signature-verify.git
   cd eip712-signature-verify
   ```

2. Install dependencies:

   ```
   pnpm install
   ```

3. Create a `.env` file with your private key:

   ```
   PRIVATE_KEY=your_private_key_here
   ```

   Replace `your_private_key_here` with your actual private key.

## Testing

You can run tests from the root directory without needing to navigate into specific folders.

### Off-chain Testing

To test the off-chain signing and verification:

1. Run the off-chain test:

   ```
   pnpm run test:offchain
   ```

This will execute the `sign.js` script, demonstrating off-chain signing and verification.

### On-chain Testing

To test the on-chain signing and verification:

1. Run the on-chain tests:

   ```
   pnpm run test:onchain
   ```

This will execute the Forge tests, demonstrating on-chain signing and verification.

### Running All Tests

To run both off-chain and on-chain tests sequentially:

```
 pnpm test
```

## Project Structure

- `offchain/`: Contains JavaScript code for off-chain signing and verification
- `package.json`: Project configuration and scripts

## Dependencies

- Ethers.js: For off-chain Ethereum interactions
- Viem: TypeScript Interface for Ethereum.
- Foundry: Toolkit for Ethereum application development

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes or improvements. For major changes, please open an issue first to discuss what you would like to change.
