// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint public count;

    // 获取
    function get() public view returns(uint) {
        return count;
    }

    // 加饭
    function inc() public {
        --count;
    }

    // 减法
    function dec() public {
        ++count;
    }

}