// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract MemoryAndStorage {
    mapping (uint => User) users;

    struct User {
        uint id;
        uint balance;
    }

    function addUsers(uint id, uint balance) public {
        users[id] = User(id ,balance);
    }

    function updateBalance(uint id, uint balance) public {
        // User memory user = users[id];        //incorrect
        // user.balance = balance;              //incorrect
        users[id].balance = balance;
    }

    function getBalance(uint id) view public returns(uint) {
        return users[id].balance;
    }
}