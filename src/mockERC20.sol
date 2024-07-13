// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import {ERC20} from "@tokenized-strategy/BaseStrategy.sol";

contract mockERC20 is ERC20 {

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _mint(msg.sender, 1e18);
    }

    function mint(address _to) external {
        uint256 _amount = 1e8;
        _mint(_to, _amount);
    }

}