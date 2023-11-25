// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract TestConstructor {
    string message;

    constructor(string memory _message){
        message = _message;
    }

    function func() public returns(string memory){
        return message;
    }
}