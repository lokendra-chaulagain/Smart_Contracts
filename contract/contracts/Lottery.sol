// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.11;

contract Lottery {
    //state variable
    address public owner; //address of the person who deploy the contract
    uint public lotteryId;
    //tracking who won the lottery
    mapping(uint => address payable) public lotteryHistory;

    //List of the player array
    //in solidity to create an array first we need to specify the type of the object that array wil contain
    //payable modifier is used for any addresses or function that receives payment/ethers
    address payable[] public players;

    //constructor
    constructor() {
        //getting the address of the person who deployed the contract
        owner = msg.sender;
        lotteryId = 1;
    }

    function getWinnerByLottery(uint id) public view returns (address payable) {
        return lotteryHistory[id];
    }

    //get balance of the smart scontract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    //get players
    //returns array of players
    //memorry indicates this is just stored in temporary in system memory only for the duration of function lifecycle

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    //player enter function
    //when player enter to our lottery system they need to send some ether so payable
    function enter() public payable {
        //requirement to enter into lottery system
        //msg.value is the value send by the user who invoked this function
        require(msg.value > .01 ether);

        //adding the player address ro players array
        //Here msg.sender is the person who want to join the lotter i.e who invoked this function
        players.push(payable(msg.sender));
    }

    //pick winner function
    //there is no any random number generator in solidity
    //blockchai is deterministic state machine i.e future state are predictable so there is no randomness in blockchain
    //and it is fully transparent
    //so lets use sudo random number
    //we are not modifying just reading so view
    function getRandomNumber() public view returns (uint) {
        //we are concatinating owner address with timestamps and passing that to 256 hashing algorithm and getting result inti uint unsigned integer
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    //pick winner function
    function pickWinner() public onlyOwner {
        //only the owner of the contract can invoke this function
        //   require(msg.sender == owner); //use this or modifier boyh same

        //get random number by calling getRandomNumber function
        //use that random number and look into players array and choose any random index of the array
        //ultimate result is to get a index from that array

        //we use modular function to get length of array because random nomber should not ne more than the players array
        uint index = getRandomNumber() % players.length;

        //transferring the funds to that address
        //transfer balance of the current smart contract address
        players[index].transfer(address(this).balance);

        //update the history
        lotteryHistory[lotteryId] = players[index];

        //increase the lotteryId
        lotteryId++;

        //reset that arry for the next round
        //lets overwrite array with length o
        players = new address payable[](0);
    }

    //modifer or require both are same but modifier promotes code reuseability
    // _; this means run all other things below the require statement
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
