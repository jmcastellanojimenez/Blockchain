**MyTokenERC20**

This project implements an ERC-20 token with pausable functionality and a maximum supply using OpenZeppelin Contracts.

**Requirements**
	•	Node.js
	•	Truffle
	•	Ganache (for local development)

**Setup**
1.	Clone the repository:
  git clone https://github.com/yourusername/MyTokenProject.git
  cd MyTokenProject
2.	Install dependencies:
   npm install
3.	Compile the smart contracts:
  truffle compile
4.	Deploy to a local network:
  truffle migrate --network development

**Testing**
  truffle test

**Pausing Functionality**
This contract uses OpenZeppelin’s Pausable contract to allow the owner to pause and unpause token transfers, minting and burning.
When the contract is paused, these actions are disabled, providing a mechanism to respond to emergencies or other situations 
requiring a halt in contract activity.

*For more information on the Pausable contract, refer to the OpenZeppelin documentation:*
https://docs.openzeppelin.com/contracts/5.x/api/utils?utm_source=chatgpt.com

**Initialize Git and Push to GitHub:**
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/yourusername/MyTokenProject.git
git push -u origin main
