// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Bank {
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

    function deposite() public payable returns (uint)   {
        balance[msg.sender] += msg.value;  //no need , internally keep track of who deposite money ect
        emit balanceAdded(msg.value, msg.sender);
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