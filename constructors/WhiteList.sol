// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract WhiteList {
    bytes32 public merkleRoot;
    address public owner;
    mapping(address => bool) public whitelistClaimed;

    mapping(address => uint256) public depositFund;
    mapping(address => uint256) public withdrawlFund;

    //call when fund is deposited
    event depositedFund(uint256 amount, address indexed depositedOwner);

    //call when fund is withdrawal
    event withdrawalFund(uint256 amount, address indexed withdrawalOwner);

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    modifier onlyWhiteList() {
        require(whitelistClaimed[msg.sender] == true, "Unauthorized User");
        _;
    }

    modifier isWithdraw(uint256 amount) {
        uint256 previousWithdrawal = withdrawlFund[msg.sender];
        require(
            depositFund[msg.sender] - previousWithdrawal >= amount,
            "Insufficient Account Balance"
        );
        _;
    }

    function claim(bytes32[] memory proof) public {
        require(!whitelistClaimed[msg.sender], "Address already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof");

        // owner = msg.sender;
        whitelistClaimed[msg.sender] = true;

        // User is in the whitelist, allow them to claim the NFT
    }

    function deposite() public payable onlyWhiteList {
        depositFund[msg.sender] += msg.value;
        emit depositedFund(msg.value, msg.sender);
    }

    function withdrawal(uint256 _amount)
        public
        onlyWhiteList
        isWithdraw(_amount)
    {
        withdrawlFund[msg.sender] += _amount;

        emit withdrawalFund(_amount, msg.sender);
    }

    function getBalance() public view returns (uint256 balance) {
        return depositFund[msg.sender] - withdrawlFund[msg.sender];
    }
}

// ["0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65", "0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb"]
// ["0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb"]
// 0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65
