// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

contract PurchaseAgreement {
    uint256 public productValue;
    //seller and buyer both gonna receive the transactio so two payable addresses
    address payable public seller;
    address payable public buyer;

    //variable to hold the state of the contract at any point of time
    enum State {
        Created,
        Locked,
        Release,
        Inactive
    }
    //this is state variable of type State enum
    State public contractState; //by default its value is Created

    //constructor is the function that get invoked one time when contract is deployed
    //we made it payable because seller sends the money while deploying contract
    constructor() payable {
        seller = payable(msg.sender); //seller deploys the contract
        productValue = msg.value / 2;
    }

    //our custom error
    /// The function cannot be called at the current state
    error InvalidState();

    modifier inState(State state_) {
        if (contractState != state_) {
            revert InvalidState();
        }
        _;
    }

    //custom error for only buyer can invoke this function
    /// Only the buyer can call this function
    error onlyBuyerErr();
    modifier onlyBuyer() {
        if (msg.sender != buyer) {
            revert onlyBuyerErr();
        }
        _;
    }

    //custom error for only seller can invoke this function
    /// Only the seller can call this function
    error onlySellerErr();

    modifier onlyseller() {
        if (msg.sender != seller) {
            revert onlySellerErr();
        }
        _;
    }

    //this is external because the buyer invoked the function from outside of this contract
    function confirmPurchase() external payable inState(State.Created) {
        //check if the buyer sends 2 times the product price.half will be returned after resolving the transaction
        require(
            msg.value == (2 * productValue),
            "Pleace send 2 times the purchase amount and half will be returned after successfull transaction"
        );
        buyer = payable(msg.sender); //here msg.sender is the buyer who invoked this purchase function

        //check if the state is Created state or not then only we proceed to Locked state

        //lets update the state
        contractState = State.Locked;
    }

    //only buyer can invoke this functon after receiving the product and tells to release the deposit
    function confirmReceived() external onlyBuyer inState(State.Locked) {
        //note always update the state first the only perdorm the transaction to avoid reentrancy atack
        contractState = State.Release;
        //return the half deposit
        buyer.transfer(productValue);
    }

    //paying to seller //only the seller can invoke this function
    function paySeller() external onlyseller inState(State.Release) {
        contractState = State.Inactive;
        seller.transfer(3 * productValue);
    }

    //Before any buyer bought anything the seller can abort the contact and cancell everything buyer can cacell only in State.created state not in other state
    function abort() external onlyseller inState(State.Created) {
        contractState = State.Inactive;
        //whwn he cancell , his fund will be released
        seller.transfer(address(this).balance);
    }
}
