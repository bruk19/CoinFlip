// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
event CoinFlipRequest(uint256 requestId);
event CoinFlipResult(uint256 requestId, bool didWin);

contract CoinFlip {
    enum ConFlipSelection {
        HEADS,
        TAILS
    }

    function flip(ConFlipSelection choice) external payable returns (uint256) {}
}
