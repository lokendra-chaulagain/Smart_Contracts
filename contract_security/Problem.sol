// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

//ACCESS CONTROL --it refers to who has access to which part of our proogram
//                --In particular who has permission to invoke certain function

contract RealEstateAgreement {
    uint256 public price;
    bool public sellerPaysClosingFees;

    constructor(uint256 _price) {
        price = _price;
        sellerPaysClosingFees = false;
    }

    function setPrice(uint256 _price) public {
        price = _price;
    }

    function setClosingFeeAgreement(bool _ownerPays) public {
        sellerPaysClosingFees = _ownerPays;
    }
}

//Here the main problem with this contract is anyone can change the price sellerClosingFees status
//It a seriious isssue in payment related contract
