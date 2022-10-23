// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./NFtMarketplaceXts.sol";
import "./utils/NftXts.sol";


contract Auction is NFtMarketplaceXts, NftXts {

    uint public auctionItemCount; 

    struct auctionItem {
        uint auctionItemId;
        IERC721 nft;
        uint tokenId;
        address payable seller;
        bool sold;
    }

    event itemListedOnAuction(
        uint auctionItemId,
        address indexed nft,
        uint tokenId,
        address indexed seller);

    event itemBoughtOnAuction(
        uint auctionItemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer);


    function listItemOnAuction(IERC721 _nft, uint _tokenId) external {
        auctionItemCount ++;
        // transfer nft
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        // add new item to items mapping
        auctionItems[auctionItemCount] = auctionItem (
            auctionItemCount,
            _nft,
            _tokenId,
            payable(msg.sender),
            false
        );
        // emit itemListed event
        emit itemListedOnAuction(
            auctionItemCount,
            address(_nft),
            _tokenId,
            msg.sender
        );
    }

    //function makeBid(tokenId, value) {


    //}

    function finishAuction(uint _auctionItemId) external {
        auctionItem storage auctionitem = auctionItems[_auctionItemId];
        require(_auctionItemId > 0 && _auctionItemId <= auctionItemCount, "item doesn't exist");
        require(msg.value >= item.price, "not enough ether to cover item price");
        require(!auctionItem.sold, "item already sold");
        // pay seller
        auctionitem.seller.transfer(item.price);
        // update item to sold
        auctionitem.sold = true;
        // transfer nft to buyer
        auctionitem.nft.transferFrom(address(this), msg.sender, auctionitem.tokenId);
        // emit itemBought event
        emit itemBoughtOnAuction(
            _auctionItemId,
            address(auctionitem.nft),
            auctionitem.tokenId,
            item.price,
            auctionitem.seller,
            msg.sender
        );
    }
}
