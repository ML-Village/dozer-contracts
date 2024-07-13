// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import "forge-std/console.sol";
import {ExtendedTest} from "./ExtendedTest.sol";

import {dozerGame, ERC20} from "../../dozerGame.sol";
import {mockPrize} from "../../mockPrize.sol";
import {mockOracle} from "../../mockOracle.sol";
import {pythOracleReader} from "../../pythOracle.sol";

contract Setup is ExtendedTest {
    // Contract instances that we will use repeatedly.
    ERC20 public asset;
    dozerGame public game;
    mockPrize public prize;
    mockOracle public oracle;
    pythOracleReader public pyth;

    mapping(string => address) public tokenAddrs;

    // Addresses for different roles we will use repeatedly.
    address public user = address(10);
    address public keeper = address(4);
    address public management = address(1);

    // Address of the real deployed Factory

    // Integer variables that will be used repeatedly.
    uint256 public decimals;
    uint256 public MAX_BPS = 10_000;

    // Fuzz from $0.01 of 1e6 stable coins up to 1 trillion of a 1e18 coin
    uint256 public maxFuzzAmount = 1e30;
    uint256 public minFuzzAmount = 10_000;

    // Default profit max unlock time is set for 10 days

    function setUp() public virtual {
        _setTokenAddrs();

        // Set asset
        asset = ERC20(tokenAddrs["DAI"]);

        // Set decimals
        decimals = asset.decimals();

        // Deploy the game 
        prize = new mockPrize();
        oracle = new mockOracle();
        game = new dozerGame("Dozer Game", "DG", address(prize), address(oracle));

        prize.setDozerGame(address(game));

        oracle.addPrice(address(asset), 1e8);

        // label all the used addresses for traces
        vm.label(keeper, "keeper");
        vm.label(address(asset), "asset");
        vm.label(management, "management");
    }




    function mintAndDepositIntoGame(
        address _user,
        address _asset,
        uint256 _amount
    ) public {
        airdrop(asset, _user, _amount);
        
        vm.prank(_user);
        ERC20(_asset).approve(address(game), _amount);

        vm.prank(_user);
        game.deposit(_asset, _amount);

    }


    function airdrop(ERC20 _asset, address _to, uint256 _amount) public {
        uint256 balanceBefore = _asset.balanceOf(_to);
        deal(address(_asset), _to, balanceBefore + _amount);
    }


    function _setTokenAddrs() internal {
        tokenAddrs["WBTC"] = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        tokenAddrs["YFI"] = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e;
        tokenAddrs["WETH"] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        tokenAddrs["LINK"] = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
        tokenAddrs["USDT"] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
        tokenAddrs["DAI"] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        tokenAddrs["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    }
}
