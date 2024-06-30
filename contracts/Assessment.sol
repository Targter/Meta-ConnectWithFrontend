// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Assessment {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
        // just check the initBalance must match sent value: 
          require(msg.value == initBalance, "Initial balance must match sent value");

    }

    //adding OnlyOwner function sent message when someone else is login : 
  modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner of this account");
        _;
    }
    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;


        //no need to do this : 
        // make sure this is the owner
        // require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        //check this carefully: 
        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        // no need of this i am running a function in this: 
        // require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;
        // it call the owner on every withrawal:
        (bool success, ) = owner.call{value: _withdrawAmount}("");
        require(success, "Transfer failed.");

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }
}
