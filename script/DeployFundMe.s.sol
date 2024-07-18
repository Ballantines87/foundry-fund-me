// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Anything before a startBroadcast - not gonna send a trx
        HelperConfig helperConfig = new HelperConfig();

        // destructuring the activeNetworkConfig struct here, but we don't have to use (,,,)
        // to destrcture on the left side because we only have 1 field inside the activeNetworkConfig struct
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        // After startBroadcast -> Real trx (and cost gas)
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
