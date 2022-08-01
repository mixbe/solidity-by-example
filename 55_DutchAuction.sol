// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}


/*
1. 部署NFT-ERC721合约
2. 铸造NFT （地址，id）
3. 部署合约 DutchAuction
4. 构造函数（起拍价， 1， id， nft）
5. NFT 合约中需要对 DutchAuction 合约进行 批准操作
6. DutchAuction 合约 进行购买（可以使用新地址）
*/

// 荷兰式拍卖
contract DutchAuction {
    // immutable 修饰的变量是在部署的时候确定变量的值, 它在构造函数中赋值一次之后,就不在改变, 这是一个运行时赋值, 就可以解除之前 constant 不支持使用运行时状态赋值的限制.
    // constant 修饰的变量需要在编译期确定
    // 拍卖周期
    uint private constant DURATION = 7 days;

    // 拍卖产品为 nft
    IERC721 public immutable nft;
    // nftId
    uint public immutable nftId;
    // 出售者
    address payable public immutable seller;
    // 起拍价格
    uint public immutable startingPrice;
    // 起拍时间
    uint public immutable startAt;
    // 过期时间
    uint public immutable expiresAt;
    // 没秒的折扣率
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _nft,    
        uint _nftId
    ) {
        // 出售者具有 payable
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;
        // 确认拍卖价格不能为负数
        require(_startingPrice >= _discountRate * DURATION, "starting price < min");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    // 获取当前拍品价格
    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    // 购买时候，需要传入主币
    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");
        // 获取当前最新价格
        uint price = getPrice();
        // 价格判断
        require(msg.value >= price, "ETH < price");
        // nft发送
        nft.transferFrom(seller, msg.sender, nftId);
        // 退还金额
        uint refund = msg.value - price;
        if (refund > 0) {
            // 返回购买者的账户
            payable(msg.sender).transfer(refund);
        }
        // 自毁方式(更节约gas)
        selfdestruct(seller);
    }

}



