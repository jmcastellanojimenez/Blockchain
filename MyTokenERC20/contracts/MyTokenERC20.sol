// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

// Import standard implementation of the ERC-20 token.
import "@openzeppelin/contracts@5.0.0/token/ERC20/ERC20.sol";
// Import the Ownable contract from OpenZeppelin with ownership functionality.
import "@openzeppelin/contracts@5.0.0/access/Ownable.sol";
// Import Pausable from OpenZeppelin to enable pausing functionality.
import "@openzeppelin/contracts@5.0.0/security/Pausable.sol";

contract MyTokenERC20 is ERC20, Ownable, Pausable {

    // Define a custom error for exceeding the maximum token supply.
    error MyTokenMaxSupply();

    // Events to log when tokens are minted or burned.
    event MintMyTokenERC20(address indexed account, uint256 amount);
    event BurnMyTokenERC20(address indexed account, uint256 amount);

    // Private variable to store the maximum token supply.
    uint256 private _maxSupply;

    // Constructor to initialize the token contract.
    constructor(uint256 _maxSupply_) ERC20("MyToken ERC20", "MTK") Ownable(msg.sender) {
        _maxSupply = _maxSupply_; // Set the maximum supply of the token.
    }

    // Function to mint new tokens.
    function mint(address account, uint256 value) external onlyOwner whenNotPaused {
        if (totalSupply() + value > _maxSupply) {
            revert MyTokenMaxSupply();
        }
        _mint(account, value);
        emit MintMyTokenERC20(account, value);
    }

    // Function to burn tokens.
    function burn(uint256 value) external whenNotPaused {
        _burn(msg.sender, value);
        emit BurnMyTokenERC20(msg.sender, value);
    }

    // Pause all token-related actions (transfers, minting, burning).
    function pause() external onlyOwner {
        _pause();
    }

    // Unpause all token-related actions.
    function unpause() external onlyOwner {
        _unpause();
    }

    // Override transfer functions to enforce pausing functionality.
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
