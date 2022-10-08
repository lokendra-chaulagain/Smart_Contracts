// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

//Reentrancy Attack --Malicious contract attacks the victim contract and takes all the funds from victim contract
//                  --In such attack the attacker contract gains more control over the contract execution and perforn the tasks that are not indended.
//                  --DAO attack of 2016 of 60M is the similar attack

import "@openzeppelin/contracts/utils/Address.sol";
import "hardhat/console.sol";

contract EtherBank {
    using Address for address payable;

    //keep  track of all savings account balances
    mapping(address=>uint) public balances;


//deposit funds into sender account
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    //withdraw all funds from the user account
    function withdraw() external {
        require(
            balances[msg.sender] > 0,
            "Withdrawl amount exceeds the available balances"
        );
        console.log(**);
        console.log("EEtherBamk balance: ",address(this).balance);
        console.log("Attacker balance: ",balances(this).sender);
        console.log(**);

        payable(msg.sender).sendValue(balances[msg.sender]);
        balances[msg.sender]=0;
      

    }

//check the total balance of the Ether Bank Contract
 function getBalance() external view returns(uint){
     return address(this).balance;
 }

}
