// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// 通过合约 调用 其他合约的方法
contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) external {
        x = _x;
    }

    function getX() external view returns (uint) {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable{
        x = _x;
        value = msg.value;
    }
    
    function getXandValue() external view returns(uint,uint){
        return (x, value);
    }
}

contract Caller{
    // 方式1
    // function setX(address _adr, uint _x) external {
    //     Callee(_adr).setX(_x);
    // }

    //  方式2
    function setX(Callee _adr, uint _x) external {
        _adr.setX(_x);
    }

    function getX(address _adr) external view returns(uint x){
        x = Callee(_adr).getX();
    }

    function setXandReceiveEther(address _adr, uint _x) external payable{
        // 发送的主币, 参数一起传递给下一个合约
        Callee(_adr).setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(address _adr) external view returns(uint x, uint value) {
        (x, value) = Callee(_adr).getXandValue();
    }


}