const { ethers } = require("hardhat");
const { expect } = require("chai");
const { ContractFunctionVisibility } = require("hardhat/internal/hardhat-network/stack-traces/model");

// 10000 ether for each signer
describe("Weapon Ecosystem", () => {
    let contractFactory, contract, owner, address1;
    beforeEach(async () => {
        contractMarket = await ethers.getContractFactory('WeaponMarket');
        [owner, alice, bob] = await ethers.getSigners();
        weaponMarket = await contractMarket.deploy();
    })
    /*
    describe('WeaponFactory process', () => {
        it('Should return the right balance', async () => {
            await weaponFactory.createNewWeapon(alice.address);
            await weaponFactory.createNewWeapon(alice.address);
            count = await weaponFactory.balanceOf(alice.address);
            console.log(count);
            expect(count).to.equal('2');
        })
        it('Should decrease the durability to 250 then increase back to 255', async () => {
            await weaponFactory.createNewWeapon(alice.address);
            await weaponFactory.damage(0);
            durability_1 = await weaponFactory.durabilityOf(0);
            await weaponFactory.repairWeapon(alice.address, 0);
            durability_2 = await weaponFactory.durabilityOf(0);
            expect(durability_2).to.equal(255);
        })
    })
    */ 
    describe('WeaponMarket interactions', () => {
        it('Correct setup', async () => {
            name = await weaponMarket.name();
            expect(name).to.equal('Weapon');
        })

        it('Should create a sale on the market', async ()=> {
            await weaponMarket.createNewWeapon(alice.address);
            await weaponMarket.createSale(alice.address, 0, 5);
            price = await weaponMarket.getPrice(0);
            expect(price).to.equal(5);
        })
        
        it('Should change weapon 0 ownership to bob', async ()=> {
            await weaponMarket.createNewWeapon(alice.address);
            await weaponMarket.createSale(alice.address, 0, 500);
            await weaponMarket.connect(bob).purchaseWeapon(0, {
                value: ethers.utils.parseEther("0.5"),
            });
            holder = await weaponMarket.ownerOf(0);
            expect(holder).to.equal(bob.address);
        })

        it('Should transfer ether from contract to alice', async () => {
            await weaponMarket.createNewWeapon(alice.address);
            await weaponMarket.createSale(alice.address, 0, 500);
            
            await weaponMarket.connect(bob).purchaseWeapon(0, {
                value: ethers.utils.parseEther("0.5"),
            });
            
            const before = await alice.getBalance();
            const oBefore = await owner.getBalance();
            await weaponMarket.connect(alice).withdrawBalance();
            const after = await alice.getBalance();
            const oAfter = await owner.getBalance();
            const ethAmount = ethers.utils.formatEther(after);
            
            console.log(`Old balance for Alice:    ${before}`);
            console.log(`New balance for Alice:    ${ethAmount}`);
            console.log(`Difference of Owner:      ${oBefore - oAfter}`);
        })
    })
});