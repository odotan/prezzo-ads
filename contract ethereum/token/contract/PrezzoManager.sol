pragma solidity ^0.4.0;

import "./Prezzo.sol";

contract PrezzoManager {

    struct PrezzoAd {
        uint amount;
    }

    Prezzo token;
    mapping(address => mapping(bytes32 => PrezzoAd)) ads;

    function PrezzoManager(address _prezzoTokenAddress) {
        token = Prezzo(_prezzoTokenAddress);
    }

    function registerAd(address receiver, bytes32 requiredHash, uint amount) {
        if (amount <= 0) throw;
        if (token.allowance(msg.sender, this) < amount) throw;
        if (!token.transferFrom(msg.sender, this, amount)) throw;

        PrezzoAd ad = ads[receiver][requiredHash];
        if (ad.amount > 0) throw;
        ad.amount = amount;
    }

    function redeemPrezzi(bytes code) {
        bytes32 hash = sha3(code);
        PrezzoAd ad = ads[msg.sender][hash];
        if (ad.amount == 0) throw;
        uint amount = ad.amount;
        delete ads[msg.sender][hash];

        uint myBalance = token.balanceOf(this);
        uint diff = 0;
        if (amount > myBalance) diff = amount - myBalance;
        if (diff > 0) token.mint(diff);
        token.transfer(msg.sender, amount);
    }

}
