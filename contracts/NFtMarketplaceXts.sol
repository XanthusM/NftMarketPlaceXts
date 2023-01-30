// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./utils/NftXts.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract NFtMarketplaceXts is ReentrancyGuard, NftXts {
    
    // Variables
    address payable public immutable feeAccount; // the account that receives fees
    uint public immutable feePercent; // the fee percentage on sales 
    uint public itemCount;  

    struct Item {
        uint itemId;
        IERC721 nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    event itemListed(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller);

    event itemBought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer);

    event itemCanceled(
        uint itemId,
        address indexed nft,
        uint tokenId,
        address indexed seller);


    // itemId -> Item
    mapping(uint => Item) public items;

    constructor(uint _feePercent) {
        feeAccount = payable(msg.sender);
        feePercent = _feePercent;
    }

    function listItem(IERC721 _nft, uint _tokenId, uint _price) external nonReentrant {
        require(_price > 0, "Price must be greater than zero");
        // increment itemCount
        itemCount ++;
        // transfer nft
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        // add new item to items mapping
        items[itemCount] = Item (
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );
        // emit itemListed event
        emit itemListed(
            itemCount,
            address(_nft),
            _tokenId,
            _price,
            msg.sender
        );
    }

    function buyItem(uint _itemId) external payable nonReentrant {
        Item storage item = items[_itemId];
        require(_itemId > 0 && _itemId <= itemCount, "item doesn't exist");
        require(msg.value >= item.price + ((item.price/100) * feePercent), "not enough ether to cover item price and market fee");
        require(!item.sold, "item already sold");
        // pay seller and feeAccount
        item.seller.transfer(item.price);
        feeAccount.transfer((item.price/100) * feePercent);
        // update item to sold
        item.sold = true;
        // transfer nft to buyer
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);
        // emit itemBought event
        emit itemBought(
            _itemId,
            address(item.nft),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    }

    function cancelItem(uint _itemId) external nonReentrant {
        Item storage item = items[_itemId];
        // decrease itemCount
        itemCount = itemCount - 1;
        // transfer nft
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);
        item.sold = true;
        // emit itemCanceled event
        emit itemCanceled(
            itemCount,
            address(item.nft),
            item.tokenId,
            msg.sender
        );
    }
}