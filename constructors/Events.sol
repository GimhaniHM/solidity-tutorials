// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract TestEvent {
    mapping(address => uint) balance;
    address owner;

    event balanceAdded(uint amount, address indexed depositedTo);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addBalance(uint _toAdd) public onlyOwner returns (uint) {
        balance[msg.sender] += _toAdd;
        emit balanceAdded(_toAdd, msg.sender);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;

    }

    function transfer(address reciever, uint amount) public {
         require(balance[msg.sender] >= amount, "Balance not sufficient");
         require(msg.sender != reciever, "Don't transfer money to yourself");

         uint previousSenderBalance = balance[msg.sender];

         _transfer(msg.sender, reciever, amount);

         assert(balance[msg.sender] == previousSenderBalance - amount);
    }


}