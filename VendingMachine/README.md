# Vending Machine

A simple Ethereum-based vending machine that allows users to:
- Add and restock products (only the owner).
- Purchase products using Ether.
- Withdraw the balance (only the owner).

## Features
- Owner management.
- Events for product management and purchases.
- Secure Ether transactions.

## Deployment
### Prerequisites
1. Install Node.js
2. Install Hardhat:
   npm install --save-dev hardhat
3. Set up an Ethereum network (e.g., Rinkeby) and configure your Hardhat config.js.
### Steps
1. Compile the contract:
   npx hardhat compile
2. Deploy the contract:
   npx hardhat run scripts/deploy.js --network <network>
   Note: Replace <network> with the target network (e.g., rinkeby).

## Tests
1. Run the unit tests using Hardhat:
   npx hardhat test

## Project Structure
VendingMachine/

├── contracts/

│   └── VendingMachine.sol   # Smart contract code

├── scripts/

│   └── deploy.js            # Deployment script

├── test/

│   └── VendingMachine.test.js  # Unit tests

├── README.md                # Project documentation

## Future Improvements
- Add front-end integration for easy user interaction.
- Enhance the contract with ERC20 token support.
- Implement additional security measures (e.g., reentrancy guards).
