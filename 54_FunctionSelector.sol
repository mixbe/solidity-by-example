// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//  函数签名
// 虚拟机是如何找到函数的

contract FunctionSelector {
    // 获取函数签名
    // "transfer(address,uint256)" => 0xa9059cbb
    function getSelector(string calldata _func) external pure returns(bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}


contract Receiver {
    event Log(bytes data);
    function transfer(address _to, uint _amount) external {
        // 0xa9059cbb
        // 0000000000000000000000004b20993bc481177ec7e8f571cecae8a9e22c02db
        // 0000000000000000000000000000000000000000000000000000000000000002
        emit Log(msg.data);
    }
}