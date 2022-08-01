// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

/*
1. nft-erc721 合约部署
2. 
*/
contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public seller;
    uint public endAt;
    // 是否已经开始
    bool public started;
    // 是否已经结束
    bool public ended;

    // 最高的出价者的地址
    address public highestBidder;
    // 最高的出价者的出价 (开始为起拍价)
    uint public highestBid;
    // 每一个出价者的出价
    mapping(address => uint) public bids;

    constructor(
        address _nft,
        uint _nftId,
        uint _startingBid  // 起拍价格
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;

        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    // 开始拍卖
    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");
        // 销售者 nft 发送到当前合约
        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        // 结束时间
        // endAt = block.timestamp + 7 days;
        endAt = uint32(block.timestamp + 60);

        emit Start();
    }

    // 参与拍卖者调用
    function bid() external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        // 叫拍金额 大于 上一次价格
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            // 累加的目的，是为了最后一次性退还
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        // 参与拍卖事件
        emit Bid(msg.sender, msg.value);
    }

    // 参与者可以取回出价
    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }


    // 不需要校验调用者的身份
    // 注意，这块并没有销毁合约，没有主动去退还没有拍的成功的参与者，需要参与
    // 主动去调用 withdraw
    function end() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
