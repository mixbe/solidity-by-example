// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// ICounter 接口的实现
contract Counter{
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}