// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/console.sol";
import {Setup, ERC20} from "./utils/Setup.sol";

contract OperationTest is Setup {
    function setUp() public virtual override {
        super.setUp();
    }


    function test_operation(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        // Deposit into strategy
        mintAndDepositIntoGame(user, address(asset), _amount);

        assertEq(game.tokenId(), 1, "!tokenId");
        assertEq(game.balanceOf(user), 1, "!balanceOf");

        // TODO : finish epoch & claim winnings 
        uint256[] memory _amounts;
        address[] memory _tokens;

        _amounts = new uint256[](1);
        _tokens = new address[](1);
        _amounts[0] = _amount / 2;
        _tokens[0] = address(asset);

        prize.addResults(0, _amounts, _tokens);

        skip(2 hours);
        vm.roll(1);

        game.processEpoch();

        vm.prank(user);
        game.claimWinning(0);

        assertEq(asset.balanceOf(user), _amount / 2, "!balanceOfWinnings");
        assertEq(game.balanceOf(user), 0, "!balanceOf");


    }

}
