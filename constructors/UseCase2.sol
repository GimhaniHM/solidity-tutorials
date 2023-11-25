// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract Bank{
    mapping(address => uint) public depositFund;
    mapping (address => uint) public withdrawlFund;

    address owner;

    //call when fund is deposited
    event depositedFund(uint amount, address indexed depositedOwner);

    //call when fund is withdrawal
    event withdrawalFund(uint amount, address indexed  withdrawalOwner);

    modifier onlyOwner(){
        require(msg.sender == owner, "Must be the owner");
        _;
    }

    modifier isWithdraw(uint amount) {
        uint previousWithdrawal = withdrawlFund[msg.sender];
        require(depositFund[msg.sender] - previousWithdrawal >= amount, "Insufficient Account Balance");
        _;
    }
    

    constructor() {
        owner = msg.sender;
    }

    function deposite() public onlyOwner payable {
        depositFund[msg.sender] += msg.value;
        emit depositedFund(msg.value, msg.sender);
    }

    function withdrawal(uint _amount) public onlyOwner isWithdraw(_amount) {
        withdrawlFund[msg.sender] += _amount;

        emit withdrawalFund(_amount, msg.sender);

    }

    function getBalance() public view returns (uint balance){
        return depositFund[msg.sender] - withdrawlFund[msg.sender];
    }
}