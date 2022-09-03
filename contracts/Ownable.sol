// contracts/Ownable.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
  
contract Ownable 
{
  address private _owner;
  
  // Sets the original owner of 
  // contract when it is deployed
  constructor() {
    _owner = msg.sender;
  }
  
  // Publicly exposes who is the
  // owner of this contract
  function owner() public view returns(address) {
    return _owner;
  }
  
  modifier onlyOwner() {
    require(isOwner(),
    "Function accessible only by the owner !!");
    _;
  }
  
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }
}