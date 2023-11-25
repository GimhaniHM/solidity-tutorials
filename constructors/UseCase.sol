// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract UseCase {
    mapping(address => uint) balance;

    address owner;

    // modifier onlyOwner {
    //     require(msg.sender == owner, "Not allowed");
    //     _;
    // }

    constructor(){
        owner = msg.sender;
    }

    function addbalance(uint toAdd) public returns (uint) {
        balance[msg.sender] += toAdd;
        return balance[msg.sender];
    }

    // function getBalance(address user) public onlyOwner view returns (uint) {
    //     return balance[user];
    // }

    function getBalance(address user) public  view returns (uint) {
        require(msg.sender == owner, "Not allowed");
        return balance[user];
    }

    function getAnyBalance(address user) public view returns (uint) {
        return balance[user];
    }
}