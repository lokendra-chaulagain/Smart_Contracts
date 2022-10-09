// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

contract VendingMaching {
    //state variable
    address public ownwer; //address of the deployer

    //mapping of etherium addresses to the no of donuts each address owns
    mapping(address => uint) public donutBalances;

    //constructor
    constructor() {
        ownwer = msg.sender;
        //sender is the address of the originator of the function
        //address of the person who deployed the contract

        //setting initial donut balance to 100
        donutBalances[address(this)] = 100;
        //address(this) is the address of this contract
    }

    //view means this function is not modifying any data on the blockchain
    //but can read data from  the blockchain

    //pure means this function is not modifying any data on the blockchain
    //and also cannot read data from  the blockchain

    //get vanding machine balance function
    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    //restock function
    //this allows the owner to add new donuts to the machine

    function restock(uint amount) public {
        //only the owner can restock the vending machine/owner of the contract
        //require statement is used whic takea two parameter
        require(
            msg.sender == ownwer,
            "Only the owner can restock this machine"
        );
        donutBalances[address(this)] += amount;
    }

    //payable keyword is used to any function which needs to receive ether
    //purchase function

    function purchase(uint amount) public payable {
        require(
            msg.value >= amount * 2 ether,
            "You must pay at least 2 ether per donut"
        );
        require(
            donutBalances[address(this)] >= amount,
            "Not enough donuts in stock to fulfill purchase request"
        );
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }
}
