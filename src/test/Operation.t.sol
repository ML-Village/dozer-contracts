// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/console.sol";
import {Setup, ERC20} from "./utils/Setup.sol";

import {pythOracleReader} from "../pythOracle.sol";

import {mockERC20} from "../mockERC20.sol";

contract OperationTest is Setup {
    function setUp() public virtual override {
        super.setUp();
    }


    function test_deposit(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        // Deposit into strategy
        mintAndDepositIntoGame(user, address(asset), _amount);

        assertEq(game.tokenId(), 1, "!tokenId");
        assertEq(game.balanceOf(user), 1, "!balanceOf");

    }

    function test_multiple_deposits(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        // Deposit into strategy
        uint256 nTokens = 10;
        for (uint256 i = 0; i < nTokens; i++) {
            mockERC20 newAsset = new mockERC20("MockAsset", "MA");
            oracle.addPrice(address(newAsset), 1e8);
            address _newUser = address(uint160(i+1000));
            airdrop(ERC20(address(newAsset)), _newUser, _amount);
            mintAndDepositIntoGame(_newUser, address(newAsset), _amount);
            assertEq(game.balanceOf(_newUser), 1, "!balanceOf");

        }

    }


    function test_claim(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        // Deposit into strategy
        mintAndDepositIntoGame(user, address(asset), _amount);
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


    function test_oracle(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        address altAsset = tokenAddrs["WBTC"];

        airdrop(ERC20(altAsset), user, _amount);

        vm.prank(user);
        ERC20(altAsset).approve(address(game), _amount);

        vm.prank(user);
        vm.expectRevert();
        game.deposit(altAsset, _amount);


        oracle.addPrice(altAsset, 1e8);

        vm.prank(user);
        game.deposit(altAsset, _amount);

        assertEq(game.tokenId(), 1, "!tokenId");
        assertEq(game.balanceOf(user), 1, "!balanceOf");


    }

    function test_pyth_oralce(uint256 _amount) public {
        vm.assume(_amount > minFuzzAmount && _amount < maxFuzzAmount);

        address altAsset = tokenAddrs["WBTC"];

        airdrop(ERC20(altAsset), user, _amount);

        // https://docs.pyth.network/price-feeds/contract-addresses/evm
        pyth = new pythOracleReader(0x4305FB66699C3B2702D4d05CF36551390A4c69C6);
        game.setOracle(address(pyth));

        pyth.addToken(address(asset), 0xb0948a5e5313200c632b51bb5ca32f6de0d36e9950a942d19751e833f70dabfd);

        mintAndDepositIntoGame(user, address(asset), _amount);

    }


}
