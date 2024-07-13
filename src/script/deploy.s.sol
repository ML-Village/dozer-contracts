// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import "forge-std/Script.sol";

import {dozerGame, ERC20} from "../dozerGame.sol";
import {mockPrize} from "../mockPrize.sol";
import {mockOracle} from "../mockOracle.sol";

contract deployScript is Script {

    mockPrize public prize;
    mockOracle public oracle;
    dozerGame public game;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        prize = new mockPrize();
        oracle = new mockOracle();
        game = new dozerGame("Dozer Game", "DG", address(prize), address(oracle));

        vm.stopBroadcast();
    }


}