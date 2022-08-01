// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;



// 工厂合约
// 通过合约调用合约， new 方法


contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }

}

contract AccountFactory {
    Account[] public accounts;

    function createAccount(address _owner) external payable {
        Account account = new Account(_owner);
        accounts.push(account);
    }

}