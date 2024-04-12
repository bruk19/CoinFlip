// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
event CoinFlipRequest(uint256 requestId);
event CoinFlipResult(uint256 requestId, bool didWin);

struct CoinFlipStatus {
  uint256 randomWord;
  address player;
  bool didWin;
  CoinFlipSelection choice;
}

contract CoinFlip {
    enum ConFlipSelection {
        HEADS,
        TAILS
    }

    mapping(uint256 => CoinFlipStatus) public statuses;

    function flip(CoinFlipSelection choice) external payable returns (uint256) {}
}
