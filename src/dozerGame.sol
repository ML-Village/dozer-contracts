// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import {ERC20} from "@tokenized-strategy/BaseStrategy.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IOracle {
    function getValue(address _token, uint256 _amount) external view returns(uint256);
}

interface IPrizeDetails {
    function getResults(uint256 _epochNumber) external view returns(uint256[] memory, address[] memory);
}

contract dozerGame is ERC721 {

    using SafeERC20 for ERC20;


    // EPOCH Specific mappings (store relevant info for that epoch for tracking winnings)
    mapping(uint256 => uint256[]) public resultsAmounts;
    mapping(uint256 => address[]) public resultsTokens;
    mapping(uint256 => uint256) public epochEntrants;

    // TOKEN Specific mappings (i.e. tracking deposits / epochs for token ID)
    // We map token ID to epoch number to track when prize can be claimed 
    mapping(uint256 => uint256) public epochs;
    mapping(uint256 => uint256) public entranceValue;
    IPrizeDetails public prizeDetails;
    IOracle public oracle;
    uint256 public epochNumber;
    uint256 public epochStartTime;
    uint256 public tokenId;

    uint256 constant EPOCH_DURATION = 1 hours;
    uint256 public minAmount = 10000;

    uint256 public entrantCounter;

    constructor(
        string memory _name, 
        string memory _symbol,
        address _prizeDetails,
        address _oracle
    ) ERC721(_name, _symbol) {
        prizeDetails = IPrizeDetails(_prizeDetails);
        oracle = IOracle(_oracle);
        epochStartTime = block.timestamp;
    }

    // Epoch can be processed permissionlessly by anyone if it's complete 
    function processEpoch() external {
        require(block.timestamp > (epochStartTime + EPOCH_DURATION), "Epoch Not Finished Yet");
        _completeEpoch();
        epochStartTime = block.timestamp;
    }

    function _completeEpoch() internal {
        uint256[] memory amounts;
        address[] memory tokens;
        
        (amounts, tokens) = prizeDetails.getResults(epochNumber);

        resultsAmounts[epochNumber] = amounts;
        resultsTokens[epochNumber] = tokens;

        epochEntrants[epochNumber] = entrantCounter;

        entrantCounter = 0;
        epochNumber += 1;
    }

    function deposit(address _coin, uint256 _amount) external {

        // If epoch is over, complete it before processing deposit 
        if (block.timestamp > epochStartTime + EPOCH_DURATION) {
            _completeEpoch();
            epochStartTime = block.timestamp;
        }
 
        uint256 depositValue = oracle.getValue(_coin, _amount);
        require(depositValue >= minAmount, "not enough deposited");

        ERC20(_coin).transferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, tokenId);
        epochs[tokenId] = epochNumber;
        entranceValue[tokenId] = depositValue;
        entrantCounter += depositValue;

        tokenId += 1;
    } 

    function claimWinning(uint256 _tokenId) external {
        require(epochNumber > epochs[_tokenId], "Epoch Not Finished Yet");
        require(ownerOf(_tokenId) == msg.sender, "Not Owner");
    
        uint256 _epoch = epochs[_tokenId];

        uint256 a = entranceValue[_tokenId];
        uint256 b = epochEntrants[_epoch];

        // LOOP Through prizes and transfer to winner
        uint256[] memory amounts = resultsAmounts[_epoch];
        address[] memory tokens = resultsTokens[_epoch];

        for (uint256 i = 0; i < amounts.length; i++) {

            uint256 prizeAmount = amounts[i] * a / b;
            ERC20(tokens[i]).safeTransfer(msg.sender, prizeAmount);
        }

        _burn(_tokenId);

    }


}