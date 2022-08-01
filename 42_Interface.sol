// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;



// Counter 接口
interface ICounter {
    function count() external view returns(uint);
    function inc() external;

}


contract CallInterface {
    uint public count;
    // 在下面的方便中调用接口的方法
    // 此处的地址为合约地址
    function examples(address _counter) external {
        ICounter(_counter).inc();
        count = ICounter(_counter).count();
    } 

}