// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract ViewFunc {
    string message;

    constructor(string memory _message){
        message = _message;
    }

    function hello() public view returns(string memory){
        //message = "changed value";  //not allowed
        return message;
    }

    function helloasic() public pure returns(string memory){
        return "hello world";
    }

}