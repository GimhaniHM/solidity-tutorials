// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Test {
    mapping (address => uint) balance;

    function addBalance(uint _toAdd) public returns (uint) {
        balance[msg.sender] += _toAdd;
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function transfer(address reciever, uint amount) public {
        //check balance of msg.sender
        // balance[msg.sender] -= amount;
        // balance[reciever] += amount;

        _transfer(msg.sender, reciever, amount);

        //event logs and further checks

    }

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }
}