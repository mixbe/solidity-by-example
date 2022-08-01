// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/**
自毁合约
selfdestruct
 - delete contract
 - force send ETH to any address.
*/

contract Kill{
    constructor() payable {}
    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns(uint) {
        return 123;
    }
}

contract Helper{
    // 自毁强制发送主币
    // 助手合约调用了自毁合约的方法，会导致自毁合约的主币发送到助手合约
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    // 调用自毁合约的自毁方法
    function kill(Kill _kill) external {
        _kill.kill();
    }
}

