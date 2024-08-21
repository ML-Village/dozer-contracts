// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.18;

import "forge-std/Script.sol";

import {mockERC20} from "../mockERC20.sol";

contract mint is Script {

    mockERC20 public token1;
    mockERC20 public token2;

    address public user = 0xeD08BD853B9a4Af46AB1689A209beac54f14f74E;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        token1 = mockERC20(0x9d71865290cca388D427807C971fe7f6C364f5B4);
        token2 = mockERC20(0x254aEC4487b08A53c32De73f234574246f1A0052);

        for (uint256 i = 0; i < 100; i++) {
            token1.mint(user);
            token2.mint(user);

        }

        vm.stopBroadcast();
        uint256 endTime = block.timestamp;
    }


}