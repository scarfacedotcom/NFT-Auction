// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

contract NFT_Auction {
    address public payable seller;

    bool public ended;
    bool public started;
    uint public endAt;

    uint public highestBid;
    address public highestBidder;

    mapping (address => uint) public bids;

    //events
    event Start();
    event End(address highestBidder, uint highestBid);

    constructor () {
        owner = msg.sender; 
    }

    function start(uint startingBid) public external {
        require(!started, "started");
        require(msg.sender == seller, "you are not the seller");
        started true;
        endAt = block.timeStamp + 7 days;
        highestBid = startingBid;


        emit Start();

    }

    function bid() external payable {
        require(started, "Not started yet");
        require(!end, "ended");
        require(msg.value > highestBid, "you're fucking broke");
        require(block.timeStamp < endAt, "ended");


        highestBid = msg.value;
        highestBidder = msg.sender;

    }

    function end() external {
        require(started, "auction havent started yet");
        require(block.timeStamp >= endAt, "auction havent ended yet");
        require(!ended, "auction already ended");
        ended true;

        emit(highestBidder, highestBid);
    }

}