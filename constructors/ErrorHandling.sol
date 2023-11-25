// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Test {
    mapping(address => uint) balance;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function addBalance(uint _toAdd) public returns (uint) {
        require(msg.sender == owner);
        balance[msg.sender] += _toAdd;
        return  balance[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function transfer(address reciever, uint amount) public {
        // balance[msg.sender] -= amount;
        // balance[reciever] += amount;

        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != reciever, "Don't transfer money to yourself");

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, reciever, amount);

        assert(balance[msg.sender] == previousSenderBalance - amount);  //this should always be true
    }

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
    
}