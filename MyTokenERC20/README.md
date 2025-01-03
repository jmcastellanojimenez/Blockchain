**MyTokenERC20**

This project implements an ERC-20 token with pausable functionality, allowing the contract owner to temporarily 
disable token transfers and burning when needed. Using OpenZeppelin’s Pausable and Ownable contracts, the token 
ensures secure ownership management and operational control. The contract enforces a maximum token supply, enables 
minting by the owner up to this limit, and allows users to burn their tokens. All actions, including pausing and 
unpausing, are logged for transparency and traceability.

**Requirements**
	•	Node.js
	•	Truffle
	•	Ganache (for local development)

**Setup**
1.	Clone the repository:

  git clone https://github.com/yourusername/MyTokenProject.git

  cd MyTokenProject

3.	Install dependencies:

   npm install

4.	Compile the smart contracts:

  truffle compile

5.	Deploy to a local network:

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
