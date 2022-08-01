// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// 委托调用
// 作用： 升级合约
/*
>>>>>>>> normal
A calls B, sends 100 wei
        B calls C, sends 50 wei
A ---> B  -----> C 
                msg.sender = B
                msg.value = 50
                execute code on C's state variable
                use ETH in C

>>>>>> delegate
A calls B, sends 100 wei
        B delegatecall C
A ---> B  -----> C 
                msg.sender = A
                msg.value = 100
                execute code on B's state variable
                use ETH in B
*/

// 测试合约
contract TestDelegateCall{
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num= _num;
        sender = msg.sender;
        value = msg.value;
    }


}

// 委托调用合约
contract DetegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _adr, uint _num) external payable {
        // _adr.delegatecall(abi.encodeWithSignature("setVars(uint"), _num);
        // 新写法
        (bool success, bytes memory data) =  _adr.delegatecall(abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num));
        require(success, "detelgatecall call failed");
    } 

}