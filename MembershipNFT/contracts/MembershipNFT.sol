// SPDX-License-Identifier: GPL-3.0
/*
    *** NFT Membership System with Exclusive Access ***
    Description: Create a membership system where NFT holders have exclusive access to 
    specific content or benefits (like events, discounts, or even other NFTs).
    - Features:
    Membership NFTs can have access levels (e.g., Gold, Silver, Bronze).
    Include a function to "burn" the NFT to claim unique benefits.
*/

pragma solidity 0.8.20;

// Importing OpenZeppelin libraries
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // Base contract for NFTs.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; // Adds token enumeration functionality.
import "@openzeppelin/contracts/access/Ownable.sol"; // Provides ownership access control.

// Defining the main contract
contract MembershipNFT is ERC721Enumerable, Ownable {  

    // Custom error definitions for gas efficiency
    error PepeMembershipInsufficientBalance(); // Thrown when balance is insufficient.
    error PepeMembershipNonExistentToken(); // Thrown when the token doesn't exist.
    error PepeMembershipNotTheOwner(); // Thrown when an action is attempted by someone other than the owner.
    error PepeMembershipNotAllowed(); // Thrown when the user isn't allowed to perform an action.
    error PepeMembershipExpired(); // Thrown when the membership is expired.

    // Events to track contract activities
    event NewMembershipMinted(address indexed to, uint256 tokenID, MembershipLevel level); // When a new membership NFT is minted.
    event MembershipRenewed(address indexed to, uint256 tokenID, MembershipLevel level, uint256 expiration); // When a membership is renewed.
    event MembershipBurned(address indexed owner, uint256 tokenID); // When a membership NFT is burned.

    // Counter for generating unique token IDs
    uint256 private _currentTokenId;

    // Enum defining membership levels
    enum MembershipLevel {Bronze, Silver, Gold} // Membership levels ranked by increasing access.

    // Mappings to associate each token with its membership level and expiration
    mapping(uint256 tokenID => MembershipLevel) public membershipLevels;
    mapping(uint256 tokenID => uint256 expiration) public membershipExpiration;

    // Prices for different membership levels
    uint256 bronzePrice = 0.01 ether;
    uint256 silverPrice = 0.1 ether;
    uint256 goldPrice = 0.5 ether;

    // Constructor to initialize the contract
    constructor() ERC721("Pepe Membership", "CQM") Ownable(msg.sender) {
        _currentTokenId = 0; // Start token IDs from 0.
    }

    // Function to mint a new membership NFT
    function mintPepeMembership(MembershipLevel level) external payable {
        uint256 price = getPriceForLevel(level); // Get the price for the selected level.

        if (msg.value < price) { // Ensure the user has paid enough.
            revert PepeMembershipInsufficientBalance();
        }

        _currentTokenId++; // Increment the token ID counter.

        _safeMint(msg.sender, _currentTokenId); // Mint the NFT to the user's address.
        membershipLevels[_currentTokenId] = level; // Assign the membership level.
        membershipExpiration[_currentTokenId] = block.timestamp + 365 days; // Set the expiration date to 1 year.

        emit NewMembershipMinted(msg.sender, _currentTokenId, level); // Log the minting event.
    }

    // Function to renew an existing membership
    function renewMembership(uint256 tokenID) external payable {
        if (!_exists(tokenID)) { // Check if the token exists.
            revert PepeMembershipNonExistentToken();
        }

        if (ownerOf(tokenID) != msg.sender) { // Check if the sender is the owner of the token.
            revert PepeMembershipNotTheOwner();
        }

        MembershipLevel level = membershipLevels[tokenID]; // Retrieve the membership level.
        uint256 price = getPriceForLevel(level); // Get the price for renewal.

        if (msg.value < price) { // Ensure the user has paid enough.
            revert PepeMembershipInsufficientBalance();
        }

        membershipExpiration[tokenID] += 365 days; // Extend the expiration by 1 year.

        emit MembershipRenewed(msg.sender, tokenID, level, membershipExpiration[tokenID]); // Log the renewal event.
    }

    // Helper function to get the price for a specific membership level
    function getPriceForLevel(MembershipLevel _level) public view returns (uint256) {
        if (_level == MembershipLevel.Gold) {
            return goldPrice;
        } else if (_level == MembershipLevel.Silver) {
            return silverPrice;
        } else {
            return bronzePrice;
        }
    }

    // Internal function to check if a token exists
    function _exists(uint256 _tokenID) internal view returns (bool) {
        return ownerOf(_tokenID) != address(0); // A token exists if it has an owner.
    }

    // Function to check the highest membership level of a user
    function checkMembershipLevel(address _user) public view returns (MembershipLevel) {
        uint256 balance = balanceOf(_user); // Get the number of NFTs the user owns.

        if (balance == 0) { // If the user has no NFTs, throw an error.
            revert PepeMembershipInsufficientBalance();
        }

        MembershipLevel level = MembershipLevel.Bronze; // Default to Bronze level.

        // Loop through the user's tokens to find the highest level
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenID = tokenOfOwnerByIndex(_user, i);
            MembershipLevel currentLevel = membershipLevels[tokenID];

            if (currentLevel > level) { // Update the level if a higher one is found.
                level = currentLevel;
            }
        }

        return level; // Return the highest level.
    }

    // Function to burn a membership NFT
    function burnMembership(uint256 tokenID) external {
        if (!_exists(tokenID)) { // Ensure the token exists.
            revert PepeMembershipNonExistentToken();
        }

        if (ownerOf(tokenID) != msg.sender) { // Ensure the sender is the owner of the token.
            revert PepeMembershipNotTheOwner();
        }

        _burn(tokenID); // Burn the token.
        emit MembershipBurned(msg.sender, tokenID); // Log the burn event.
    }

    // Function to check if a user's membership is active
    function isMembershipActive(address _user) public view returns (bool) {
        uint256 balance = balanceOf(_user); // Get the user's token count.

        if (balance == 0) { // If the user has no NFTs, throw an error.
            revert PepeMembershipInsufficientBalance();
        }

        uint256 tokenID = tokenOfOwnerByIndex(_user, balance - 1); // Get the latest token ID.

        return membershipExpiration[tokenID] > block.timestamp; // Check if the membership is still valid.
    }

    // Function for exclusive Gold-level access
    function exclusiveGold() external view {
        if (!isMembershipActive(msg.sender)) { // Ensure the user's membership is active.
            revert PepeMembershipExpired();
        }
        if (checkMembershipLevel(msg.sender) != MembershipLevel.Gold) { // Ensure the user has Gold-level membership.
            revert PepeMembershipNotAllowed();
        }

        // Add logic for Gold-exclusive access here.
    }

    // Function for the owner to withdraw Ether from the contract
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance); // Transfer all Ether to the owner.
    }
}

This version includes detailed comments for every section to make it beginner-friendly. Let me know if you need more clarification! 😊
