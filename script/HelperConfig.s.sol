// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

abstract contract CodeConstants {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    /*//////////////////////////////////////////////////////////////
                               CHAIN IDS
    //////////////////////////////////////////////////////////////*/
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

struct NetworkConfig {
    address priceFeed; // ETH/USD price feed address
}

contract HelperConfig is Script, CodeConstants {
    int256 constant INITIAL_PRICE_ETHUSD = 2000e8;

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // needs priceDeed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // needs priceDeed address
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Deploy the mock contract (which is like a dummy contract)
        // 2. and then return the mock addresses

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE_ETHUSD
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilEthConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilEthConfig;
    }
}
