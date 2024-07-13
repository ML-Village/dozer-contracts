// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

contract mockOracle {

    uint256 constant AMOUNT = 1e8;
    mapping(address => uint256) public prices;
    function addPrice(address _token, uint256 _price) external {
        prices[_token] = _price;
    }


    function getValue(address _token, uint256 _amount) external view returns(uint256) {
        return (prices[_token] * _amount / AMOUNT);

    }

}