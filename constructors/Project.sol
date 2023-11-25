// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;
pragma abicoder v2;

//["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]

contract Wallet {

    address[] public owners;       //array to store address of all owners
    uint limit;         //to store number of signatures required from the owners

    struct Transfer {
        uint approvals;  //number of approvals
        address reciever;
        uint amount;
        uint id;
        bool hasSent;
    }

    Transfer[] TransferRequest;

    //mapping for store the transaction approval id
    //mapping (address => uint) approvals;  //if same owner store transfer id 1,2 
    //mapping[address][transferID] => true/false.       ->.     mapping[msg.sender][5] = true;
    mapping (address => mapping (uint => bool)) approvals;

    //mapping to check whether an address is an owner
    mapping (address => bool) isOwner;

    //mapping to store balance deposite each owner
    mapping (address => uint) balance;

    ////event
    //call when fund is deposited
    event depositedFund(uint amount, address indexed depositedOwner);

    event TransferRequestCreated(uint _id, uint _amount, address _transferer, address _receiver);
    event ApprovalRecieved(uint _id, uint approvals, address approver);
    event TransferApproved(uint _id);
    event DepositedFund(address _depositor, uint _amount);

    //Should only allow people in the owners list to continue the execution.
    //msg.sender should part of the owners[] list
    modifier onlyOwner(){
        bool owner = false;
        for(uint i=0; i<owners.length; i++) {
            if(owners[i] == msg.sender) {
                owner = true;
            }
        }

        require(owner == true, "Not an owner"); 
        _;
    }

    //initialize owners list and the limit
    constructor(address[] memory _owners, uint _limit) {
        require(_owners.length > 0, "Owners required");
        require(_limit > 0 && _limit <= _owners.length, "Invalid number of signatures");

        // owners = _owners;
        // limit = _limit;

        for(uint i=0; i < _owners.length; i++) {
            address owner = _owners[i];
  
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "owner is not allowed");

            isOwner[owner] = true;
            owners.push(owner);
        }

        limit = _limit;
    }

    //function to depostite the money
    function depositFund() public onlyOwner payable {
        //since this is payable nothing to do
        balance[msg.sender] += msg.value;
        emit DepositedFund(msg.sender, msg.value);
    }

    //function to request to transfer money
    //Create an instance of the Transfer struct and add it to the TransferRequest array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwner {
        emit TransferRequestCreated(TransferRequest.length, _amount, msg.sender, _receiver);
        TransferRequest.push(
            Transfer(0, _receiver, _amount, TransferRequest.length, false)
        );
    }

    //Set your approval for one of the transfer requests.
    //Need to update the Transfer object.
    //Need to update the mapping to record the approval for the msg.sender.
    //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
    //An owner should not be able to vote twice.
    //An owner should not be able to vote on a tranfer request that has already been sent.
    function isApprove(uint _id) public onlyOwner{
        require(approvals[msg.sender][_id] == false, "Transfer Approval is rejected");
        require(TransferRequest[_id].hasSent == false, "Must sent the transfer request");

        approvals[msg.sender][_id] = true;  //set the approval
        TransferRequest[_id].approvals++;  //update the transfer object

        //call the event
        emit ApprovalRecieved(_id, TransferRequest[_id].approvals, msg.sender);

        if(TransferRequest[_id].approvals >= limit) {
            TransferRequest[_id].hasSent = true;
            payable(TransferRequest[_id].reciever).transfer(TransferRequest[_id].amount);
            emit TransferApproved(_id);
        }
    }

    // function getWalletBalance() public onlyOwner view returns(uint) {
    //     return balance[msg.sender];
    // }

    //return all transfer requests
    function getTransferRequests() public view returns (Transfer[] memory){
        return TransferRequest;
    }

    //function to get the balance of the wallet
    function getWalletBalance() public view returns(uint){
        uint totalBalance = 0;

        for(uint i=0; i<owners.length; i++){
            totalBalance += balance[owners[i]];
        }

        return totalBalance;
    }

    //function to get the balance each one have
    function getBalance() public view returns(uint){
        return balance[msg.sender];
    } 

}