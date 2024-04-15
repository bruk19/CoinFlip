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

    address constant linkAddress = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address constant vrfWrapperAddress = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;

    uint128 constant entryFees = 0.001 ether;
    uint32 constant callbackGasLimit = 1_000_000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3;

    constructor() VRF2WrapperConsumerBase(linkAddress, vrfWrapperAddress){}

    function flip(CoinFlipSelection choice) external payable returns (uint256) {
      require(msg.value == entryFees, "Entry fees not sent");
      uint256 requisedId = requestRandomness (
        callbackGasLimit,
        requestConfirmations,
        numWords
      );
    }
}
