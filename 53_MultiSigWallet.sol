// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


// https://solidity-by-example.org/app/multi-sig-wallet/
/*
1. submit a transaction
2. approve and revoke approval of pending transcations
3. anyone can execute a transcation after enough owners has approved it.
*/

// 部署构造参数： ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"],2


contract MultiSigWallet {
    // 存款
    event Deposit(address indexed sender, uint amount);
    // 提交申请
    event Submit(uint indexed txId);
    // 批准
    event Approve(address indexed owner,uint indexed txId);
    // 撤销批准
    event Revoke(address indexed owner,uint indexed txid);
    // 执行交易
    event Execute(uint indexed txId);

    // 合约所有的签名人
    address[] public owners;
    // 数组不能快速查找, 所以价格map映射
    mapping(address => bool) public isOwner;
    // 最小确认数
    uint public required;

    // 交易结构体
    struct Transaction {
        address to;     // 目标地址
        uint value;     // 交易金额
        bytes data;     // 如果是合约地址，可以执行合约函数
        bool executed;  // 执行结果
    }

    // 交易数组
    Transaction[] public transactions;
    // 记录所有的交易(交易id(签名人，签名结果)), 默认false
    mapping(uint => mapping(address => bool)) public approved;

    // 构造函数，初始化 签名者地址 & 最小签名数字
    constructor(address[] memory _owners, uint _required) {
        require(_owners.length >0, "owners required");
        require(_required >0 && _required <= _owners.length, "invalid required number of owners");
        for(uint i; i < _owners.length; i++){
            address owner = _owners[i];
            require( owner != address(0), "invalid address");
            require(!isOwner[owner], "owner is not uniqure");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    // 签名人修改器
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }
    // 交易id是否存在
    modifier txExisits(uint _txId) {
        require(_txId < transactions.length, "txId does not exits");
        _;
    }

    // 确保未被批准
    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "tx is already approved");
        _;
    }

    // 确保未被执行
    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    // 可接收主币 
    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }

    // 提交交易
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length -1);
    }

    // 批准
    function approve(uint _txId)  external onlyOwner txExisits(_txId) notApproved(_txId) notExecuted(_txId){
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender,  _txId);
    }
    // 撤回
    function revoke(uint _txId) external onlyOwner txExisits(_txId) notExecuted(_txId){
        require(approved[_txId][msg.sender], "tx is already approved");
         approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender,  _txId);
    }

    // 获取批准数
    function _getApprovalCount(uint _txId) private view returns(uint count) {
        // 因为mapping 没有遍历的内置方法，所以需要用所有key进行间接的遍历
        for (uint i; i< owners.length; i++){
            if(approved[_txId][owners[i]]){
                count += 1;
            }
        }
    }

    // 执行交易
    function execute(uint _txId) external txExisits(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        // 执行真正的交易
        (bool success,)  = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");
        emit Execute(_txId);
    }

    // 获取Owners
    function getOwners() public view returns(address[] memory){
        return owners;
    }

    // 获取交易数量
    function getTransactionCount() public view returns(uint){
        return transactions.length;
    }

    // // 获取某个具体的交易
    // function getTransaction(uint _txIndex)
    //     public
    //     view
    //     returns (
    //         address to,
    //         uint value,
    //         bytes memory data,
    //         bool executed
    //     )
    // {
    //     Transaction storage transaction = transactions[_txIndex];

    //     return (
    //         transaction.to,
    //         transaction.value,
    //         transaction.data,
    //         transaction.executed
    //     );
    // }





}