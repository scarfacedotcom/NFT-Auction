// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {IERC721} from "./IERC721.sol";

contract NFT_Auction {
    address public seller;
    address public owner;

    bool public ended;
    bool public started;
    uint public endAt;

    uint public highestBid;
    address public highestBidder;

    mapping(address => uint) public bids;

    // NFT parameters
    IERC721 public nft;
    uint public nftid;

    //events
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function start(IERC721 _nft, uint _nftid, uint startingBid) public {
        require(!started, "started");
        require(msg.sender == seller, "you are not the seller");

        highestBid = startingBid;

        nft = _nft;
        nftid = _nftid;
        started = true;
        endAt = block.timestamp + 7 days;

        nft.transferFrom(msg.sender, address(this), nftid);

        emit Start();
    }

    function bid() external payable {
        require(started, "Not started yet");
        require(!ended, "ended");
        require(msg.value > highestBid, "you're fucking broke");
        require(block.timestamp < endAt, "ended");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);
    }

    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool sent, bytes memory data) = payable(msg.sender).call{value: bal}(
            ""
        );
        require(sent, "could not withdraw");

        emit Withdraw(msg.sender, bal);
    }

    function end() external {
        require(started, "auction havent started yet");
        require(block.timestamp >= endAt, "auction havent ended yet");
        require(!ended, "auction already ended");
        ended = true;

        if(highestBidder != address(0)){
            nft.transfer(highestBidder, nftid);
            (bool sent, bytes memory data) = seller.call{value: highestBid}(
            ""
        );
        require(sent, "could not withdraw");

        } else {
            nft.transfer(seller, nftid);
        }

        emit End(highestBidder, highestBid);
    }
}
