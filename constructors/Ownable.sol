// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Ownable {
    address internal  owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }
} 