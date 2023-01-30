// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./Auction.sol";
contract AuctionFactory {
    Auction[] private _auctions;
    function createAuction(
    ) public {
        Auction auction = new Auction(
            msg.sender
        );
        _auctions.push(auction);
    }
    function allAuctions(uint256 limit, uint256 offset)
        public
        view
        returns (Auction[] memory coll)
    {
        return coll;
    }
}
