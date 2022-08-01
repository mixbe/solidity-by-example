// SPDX-License-Identifier: MIT


pragma solidity ^0.8.10;

// 3 ways to send ETH
// transfer (2300 gas, throws error)
// send (2300 gas, throws error)
// call (forward all gas or set gas, returns bool)
  /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

contract SendEther{
        
    // 合约存入主币，有2中方式, 构造函数接收主币
    constructor() payable {}

    // fallback() external payable{} , fallabck 可接收参数

    receive() external payable {}

    function sendViaTransfer(address payable _to, uint _val) external payable{
        _to.transfer(_val);
        //_to.transfer(123);
    }

    function sendViaSend(address payable _to) external payable{
        bool sent = _to.send(msg.value);
        //bool sent = _to.send(123);
        require(sent, "Failed to send ETH");

    }

    function sendViaCall(address payable _to) external payable{
        (bool sent,) = _to.call{value:msg.value}("");
        //(bool sent,) = _to.call{value: 123}("");
        require(sent, "Failed to sent ETH");
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

}


contract ReceiveEther{
    event Log(uint amount, uint gas);


    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    fallback() external payable{}

    function getBalance() public view returns (uint){
        return address(this).balance;
    }


}