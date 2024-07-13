// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import "forge-std/Script.sol";

import {mockERC20} from "../mockERC20.sol";

contract deployToken is Script {

    mockERC20 public token;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        token = new mockERC20("SHITCOIN", "SHIT");

        

        vm.stopBroadcast();
    }


}