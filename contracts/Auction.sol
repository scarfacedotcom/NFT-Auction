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

    constructor () {
        owner = msg.sender; 
    }

    function start() public external {
        require(!started, "started");
        require(msg.sender == seller, "you are not the seller");
        started true;
        endAt = block.timeStamp + 7 days;


        emit Start();

    }

}