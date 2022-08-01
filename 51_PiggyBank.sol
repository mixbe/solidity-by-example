// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// 小猪存钱罐合约
contract PiggyBank {
    // 存钱事件
    event Deposit(uint amount);
    // 取钱事件
    event Withdraw(uint amount);
    // 部署合约时候，直接初始化合约拥有者
    address public owner = msg.sender;
    
    receive() external payable {
        emit Deposit(msg.value);
    }

    function withdraw() external {
        // 判断是否是合约拥有者
        require(msg.sender == owner, "not owner");
        // 发送取现事件
        emit Withdraw(address(this).balance);
        // 销毁合约，余额直接到发起者
        selfdestruct(payable(msg.sender));
    }

}

