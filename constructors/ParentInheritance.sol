// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Ownable.sol";

interface GovernmentInterface {
    function addTransaction(address _from, address _to, uint _amount) external; 
    
} 

contract Bank  is Ownable{

    GovernmentInterface governmentinstance = GovernmentInterface(0x56a2777e796eF23399e9E1d791E1A0410a75E31b);

    mapping(address => uint) balance;
    event  depositDone(uint amount, address indexed depositedeTo);

    function deposite() public payable returns (uint)   {
        balance[msg.sender] += msg.value;  //no need , internally keep track of who deposite money ect
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint amount, address payable sender) public onlyOwner returns (uint){
        require(balance[msg.sender] >= amount, "Insufficient balance");
        sender.transfer(amount);
        balance[sender] -= amount;
    } 

    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }

    function getOwner() public view returns (address) {
        return owner;
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

        governmentinstance.addTransaction(msg.sender, reciever, amount);

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }
}