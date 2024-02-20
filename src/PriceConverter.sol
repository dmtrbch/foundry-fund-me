// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI - use Interface to get contract ABI
        (, int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10); // ChainlinkPriceFeed returns number with 8 decimals, we need to add 10 more decimals 1e10 to make this value 1e18 (wei)
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // 1 ETH?
        // 2000_000000000000000000
        uint256 ethPrice = getPrice(priceFeed);
        // (2000_000000000000000000 * 1_000000000000000000) / 1e18;
        // $2000 = 1 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // multiplication will cause to have 36 decimals so return it to 18
        return ethAmountInUsd;
    }
}
