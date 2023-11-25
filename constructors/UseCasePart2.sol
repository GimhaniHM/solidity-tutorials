// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Bank{

    //Paste Merkle Root here from the calculation of the Merkle Tree (merkle_tree.js)
    bytes32 public merkleRoot = 0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65;

    mapping (address => bool) public whitelistClaimed;

    mapping(address => uint) public depositFund;
    mapping (address => uint) public withdrawlFund;

    address owner;

    //call when fund is deposited
    event depositedFund(uint amount, address indexed depositedOwner);

    //call when fund is withdrawal
    event withdrawalFund(uint amount, address indexed  withdrawalOwner);

    function whitelistMint(bytes32[] memory _merkleProof) public {
        //Make sure address hasn't already been claimed
        require(!whitelistClaimed[msg.sender], "Address already claimed");

        //Generate a leaf node from the caller of this function
        bytes32 leaf = keccak256(abi.encode(msg.sender));

        //check for an invalid proof
        // require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid Merkle Proof");
        require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid Merkle Proof");

        whitelistClaimed[msg.sender] = true;
    }

}

// [
//   "0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb",
//   "0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229"
// ]

// [
//   "0x999bf57501565dbd2fdcea36efa2b9aef8340a8901e3459f4a4c926275d36cdb"
// ]