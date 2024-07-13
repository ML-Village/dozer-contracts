// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import "forge-std/Script.sol";

import {dozerGame, ERC20} from "../dozerGame.sol";
import {mockPrize} from "../mockPrize.sol";
import {mockOracle} from "../mockOracle.sol";
import {mockERC20} from "../mockERC20.sol";

contract runGame is Script {

    mockPrize public prize;
    mockOracle public oracle;
    dozerGame public game;
    mockERC20 public token;

    address public user = 0xeD08BD853B9a4Af46AB1689A209beac54f14f74E;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        game = dozerGame(0x71c0c6eeDeFb9d30cBd396e6FC970E1a596E14b9);
        token = mockERC20(0x9C0Ee7D9a4BD2e4F0250079C87f7eFF139fA6c72);
        oracle = mockOracle(0xCEa73b11CEd2ED4eBc5A6c78E533a85325164FA2);

        oracle.addPrice(address(token), 1e18);
        token.mint(0xeD08BD853B9a4Af46AB1689A209beac54f14f74E);
        token.approve(address(game), token.balanceOf(address(0xeD08BD853B9a4Af46AB1689A209beac54f14f74E)));
        game.deposit(address(token), token.balanceOf(address(0xeD08BD853B9a4Af46AB1689A209beac54f14f74E)));


        vm.stopBroadcast();
    }


}