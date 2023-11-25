// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Test{
    mapping(address => uint) balance;

    function addBalance(uint _toAdd) public returns (uint) {
        balance[msg.sender] += _toAdd;
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }

    function getAddress() public view returns (address) {
        return msg.sender;
    }
}