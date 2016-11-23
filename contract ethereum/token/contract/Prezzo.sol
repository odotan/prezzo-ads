pragma solidity ^0.4.0;

import "./StandardToken.sol";

contract Prezzo is StandardToken {

    address creator;
    address public minter;
    string public name = "Prezzo";
    string public symbol = "FC";
    uint public decimals = 18;
    uint public INITIAL_SUPPLY = 10000;

    function Prezzo() {
        creator = msg.sender;
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

    function setMinter(address _minter) {
        if (msg.sender != creator) throw;
        minter = _minter;
    }

    function mint(uint amount) {
        if (msg.sender != minter) throw;
        balances[minter] += amount;
    }
}
