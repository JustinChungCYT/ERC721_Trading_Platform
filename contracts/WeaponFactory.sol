// contracts/WeaponFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Counters.sol";

contract WeaponFactory is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    struct Weapon{
        uint256 tokenId;
        uint8 maxDurability;
        uint8 durability;
    }

    // comply with the ERC721 contract
    mapping (uint256=>address) internal _tokenToOwner;
    mapping (address=>uint256) internal _ownerTokenCount;
    Weapon[] public weapons;

    constructor() ERC721("Weapon", "WPN") {}


    modifier isOwnerOf(address _requester, uint256 weaponId) {
        require(_requester == _tokenToOwner[weaponId]);
        _;
    }

    // viewers
    
    function ownerOf(uint256 _weaponId) public view override returns (address) {
        return _tokenToOwner[_weaponId];
    }

    function balanceOf(address _addr) public view override returns (uint256) {
        return _ownerTokenCount[_addr];
    }
    

    // passed
    function _mint(address _to, uint256 _tokenId) internal  override{
        require(_to != address(0), "ERC721: mint to the zero address");
        require(!_exists(_tokenId), "ERC721: token already minted");

        _ownerTokenCount[_to] += 1;
        _tokenToOwner[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal override {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        // Clear approvals from the previous owner
        //delete _tokenApprovals[tokenId];

        _ownerTokenCount[from] -= 1;
        _ownerTokenCount[to] += 1;
        _tokenToOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _transfer(from, to, tokenId);
    }

    // passed
    function createNewWeapon(address player) public returns (uint8) {
        uint8 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        weapons.push(Weapon(newItemId, 255 - newItemId, 255 - newItemId));
        _tokenIds.increment();

        return newItemId;
    }

    // to-do: repair fee
    function repairWeapon(address _requester, uint256 _weaponId) public isOwnerOf(_requester, _weaponId) {
        require(weapons[_weaponId].maxDurability > weapons[_weaponId].durability);
        weapons[_weaponId].durability = weapons[_weaponId].maxDurability;
    }

    // testing helper
    function damage(uint256 _weaponId) public {
        weapons[_weaponId].durability -= 5;
    }

    function durabilityOf(uint256 _weaponId) public view returns (uint8) {
        return weapons[_weaponId].durability;
    }
}