// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns(uint);
    function transfer(address recipient,uint amount) external returns(bool);
    function allowance(address owner, address spender) external view returns(uint);
    function approve(address spender, uint amount) external returns(bool);
    function transferFrom(address sender, address recipient, uint amount) external returns(bool);
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner,address indexed spender, uint value);
}

contract ERC20 is IERC20 {
    // 实现了 totalSupply()
    uint public totalSupply;
    // 实现了 balanceOf
    mapping(address => uint) public balanceOf;
    // 实现了 allowance
    mapping(address => mapping(address => uint)) public allowance;

    string public name = "Solidity by Eample";
    string public symbol = "SOLIDITY";
    // asset 精度
    uint8 public decimls = 18;

    function transfer(address recipient,uint amount) external returns(bool){
        // 发送者 减
        balanceOf[msg.sender] -= amount;
        // 接受者 加
        balanceOf[recipient] += amount;
        // 触发事件
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 批准方法
    function approve(address spender, uint amount) external returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns(bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 一般构造函数初始化 余额
    // 增加铸币方法(缺少权限)
    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // 销毁方法
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -=amount;
        emit Transfer(msg.sender, address(0), amount);
    }



}