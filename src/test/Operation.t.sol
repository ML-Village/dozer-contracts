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



    }

}
