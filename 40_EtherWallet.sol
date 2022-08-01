// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// 合约，存入，取出，必须是管理员
contract EtherWaller {
    address payable public owner;

    // 确保只能是管理员操作
    constructor(){
        owner =  payable(msg.sender);
    }

    // 只接收主币，不需要携带其他任何参数
    receive() external payable{}

    // 只有管理员才可以发期提现
    function withdraw(uint _amount) external {
        require(msg.sender == owner, "caller is not owner");
        //owner.transfer(_amount);
        
        // 更节约gas
        payable(msg.sender).transfer(_amount);


        // call 不需要加 paybale 也可以发送
        // (bool sent,)=msg.sender.call{value: _amount}("");
        // require(sent, "Fail to send ETH");
    }

    // 获取当前合余额
    function getBalance() external view returns(uint){
         return address(this).balance;
    }

}