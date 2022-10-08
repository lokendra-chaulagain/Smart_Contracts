// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

//Lets Solve this problem by giving access to only owner

contract RealEstateAgreement {
    uint256 public price;
    bool public sellerPaysClosingFees;
    address private owner;

    constructor(uint256 _price) {
        //owner is that who deploy the contract
        owner = msg.sender;
        price = _price;
        sellerPaysClosingFees = false;
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function setClosingFeeAgreement(bool _ownerPays) public onlyOwner {
        sellerPaysClosingFees = _ownerPays;
    }

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Only the owner can update the agreement !"
        );
        _;
    }
}

//Now only the owner can edit the agreement.
