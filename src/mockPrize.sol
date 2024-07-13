// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

interface IDozerGame {
    function writeResults(uint256 _epochNumber, uint256[] memory _amounts, address[] memory _tokens) external;
}

contract mockPrize is Ownable{

    mapping(uint256 => uint256[]) public resultsAmounts;
    mapping(uint256 => address[]) public resultsTokens;
    mapping(uint256 => bool) public epochCompleted;

    address keeper;
    address public dozerGame;

    constructor() {
        keeper = msg.sender;
    }

    modifier onlyKeeper() {
        require(msg.sender == keeper, "Only keeper can call this function");
        _;
    }

    function setKeeper(address _keeper) external onlyOwner {
        keeper = _keeper;
    }

    function setDozerGame(address _dozerGame) external onlyOwner {
        dozerGame = _dozerGame;
    }

    function addResults(uint256 _epochNumber, uint256[] memory _amounts, address[] memory _tokens) external onlyKeeper {
        resultsAmounts[_epochNumber] = _amounts;
        resultsTokens[_epochNumber] = _tokens;
        IDozerGame(dozerGame).writeResults(_epochNumber, _amounts, _tokens);
    }



    function getResults(uint256 _epochNumber, bool[5][5] memory _board, uint256 _nEntrants) external view returns(uint256[] memory, address[] memory, bool[5][5] memory) { 
        return (resultsAmounts[_epochNumber], resultsTokens[_epochNumber], _board);
    }

}