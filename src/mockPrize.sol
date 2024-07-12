// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

contract mockPrize {

    mapping(uint256 => uint256[]) public resultsAmounts;
    mapping(uint256 => address[]) public resultsTokens;

    function addResults(uint256 _epochNumber, uint256[] memory _amounts, address[] memory _tokens) external {
        resultsAmounts[_epochNumber] = _amounts;
        resultsTokens[_epochNumber] = _tokens;
    }


    function getResults(uint256 _epochNumber) external view returns(uint256[] memory, address[] memory) { 
        return (resultsAmounts[_epochNumber], resultsTokens[_epochNumber]);
    }

}