// contracts/WeaponMarket.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WeaponFactory.sol";
import "./Ownable.sol";

contract WeaponMarket is WeaponFactory, Ownable{
    mapping (uint256=>uint256) private _weaponPrice;  // unit: wei
    mapping (address=>uint256) private _accountEth; // unit: 0.001 ether
    uint256 constant milliEther = 10 ** 15;

    function weaponNotInMarket (uint256 _weaponId) private view returns (bool) {
        return _weaponPrice[_weaponId] == 0;
    }

    // viewers
    function getPrice(uint256 _weaponId) public view returns (uint256) {
        require(!weaponNotInMarket(_weaponId));
        return _weaponPrice[_weaponId];
    }

    function getAccountEth() public view returns (uint256) {
        return _accountEth[msg.sender];
    }


    // passed
    function createSale(address _creator, uint256 _weaponId, uint256 _price) public isOwnerOf (_creator, _weaponId) {
        require(weaponNotInMarket(_weaponId));
        _weaponPrice[_weaponId] = _price;
    }

    // passed
    function purchaseWeapon(uint256 _desiredWeaponId) external payable {
        require(!weaponNotInMarket(_desiredWeaponId));
        require(msg.value >= _weaponPrice[_desiredWeaponId] * milliEther);

        _accountEth[_tokenToOwner[_desiredWeaponId]] += _weaponPrice[_desiredWeaponId];

        _ownerTokenCount[ownerOf(_desiredWeaponId)] -= 1;
        _tokenToOwner[_desiredWeaponId] = msg.sender;
        _ownerTokenCount[msg.sender] += 1;
    }

    // passed
    function withdrawBalance() external {
        (bool success,) = msg.sender.call{value: _accountEth[msg.sender] * milliEther}(new bytes(0));
        //_to.transfer(address(this).balance);
        if(success) console.log("Transfer successed!!");
        else console.log("Failed!!");
    }
}