// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract VendingMachine {
    address public owner;
    mapping(string => uint) public productStock; // Maps product name to stock
    mapping(string => uint) public productPrice; // Maps product name to price
    uint public balance;

    // Events
    event ProductAdded(string productName, uint price, uint quantity);
    event ProductRestocked(string productName, uint quantity);
    event ProductPurchased(address indexed buyer, string productName, uint amountPaid);
    event BalanceWithdrawn(address indexed owner, uint amount);

    // Modifier to restrict functions to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to add new products (only owner)
    function addProduct(string memory _productName, uint _price, uint _quantity) external onlyOwner {
        require(_price > 0, "Price must be greater than zero");
        require(_quantity > 0, "Quantity must be greater than zero");

        productStock[_productName] += _quantity;
        productPrice[_productName] = _price;

        emit ProductAdded(_productName, _price, _quantity); // Emit event
    }

    // Function to restock existing products (only owner)
    function restockProduct(string memory _productName, uint _quantity) external onlyOwner {
        require(_quantity > 0, "Quantity must be greater than zero");
        require(productPrice[_productName] > 0, "Product does not exist");

        productStock[_productName] += _quantity;

        emit ProductRestocked(_productName, _quantity); // Emit event
    }

    // Function to get the balance of the vending machine (only owner)
    function getMachineBalance() external view onlyOwner returns (uint) {
        return balance;
    }

    // Function to buy a product (anyone can call)
    function buyProduct(string memory _productName) external payable {
        uint price = productPrice[_productName];
        uint stock = productStock[_productName];

        require(price > 0, "Product does not exist");
        require(stock > 0, "Product out of stock");
        require(msg.value >= price, "Insufficient payment");

        balance += msg.value;
        productStock[_productName] = stock - 1;

        emit ProductPurchased(msg.sender, _productName, msg.value);
    }

    // Function to withdraw balance to the owner's account (only owner)
    function withdrawBalance() external onlyOwner {
        uint amount = balance;
        balance = 0;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Transfer failed");

        emit BalanceWithdrawn(owner, amount);
    }

    fallback() external payable {
        revert("Direct transfers not allowed");
    }

    receive() external payable {
        revert("Use specific functions to interact with the contract");
    }
}
