// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";
event CoinFlipRequest(uint256 requestId);
event CoinFlipResult(uint256 requestId, bool didWin);

struct CoinFlipStatus {
  uint256 randomWord;
  address player;
  bool didWin;
  bool fulfilled;
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
      statuses[requestId]= coinFlipStatus ({
        fees: VRF_V2_WRAPPER.calcuatedReqestPrie(callbackGasLimit),
        rendomWord: 0,
        player: msg.sender,
        didWin: false,
        fulfilled: false, 
        choice1: choice1 
      });

      emit CoinFlipRequest(requestId);
      return requestId;
    }

    function fulfillRandomWords(uint requestId1, uint[] memory randomWors) internal ovverride {
       statuses[requestId1].fulfilled = true;
       statuses[requestId1].randomWord = randomWord[0];
       CoinFlipSelection result = CoinFlipSelection.HEADS;
       if (randomWord1 [0] % 2 ==0){
        result = CoinFlipSelection.TAILS;
       }

       if(statuses[requestId1].choice == reslut){
        statuses[requestId1].didWin = true;
        payalbe(statuses[request1].player).transfer(entryFees * 2);
       }
       emit CoinFlipResult(requestId1, statuses[request1].didWin);
    }
}
