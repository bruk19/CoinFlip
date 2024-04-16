// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";

event CoinFlipRequest(uint256 requestId);
event CoinFlipResult(uint256 requestId, bool didWin);

struct CoinFlipStatus {
  uint256 randomWord;
  address player;
  bool didWin;
  bool fulfilled;
  CoinFlip.CoinFlipSelection choice;
}

contract CoinFlip is VRFConsumerBaseV2, VRFV2WrapperConsumerBase {
    enum CoinFlipSelection {
        HEADS,
        TAILS
    }

    mapping(uint256 => CoinFlipStatus) public statuses;

    address constant linkAddress = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address constant vrfWrapperAddress = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    uint64 constant subId = 123; // Replace with your actual subscription ID
    bytes32 constant keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    uint128 constant entryFees = 0.001 ether;
    uint32 constant callbackGasLimit = 1_000_000;
    uint32 constant numWords = 1;
    uint16 constant requestConfirmations = 3;

constructor(
    address _linkAddress,
    address _vrfWrapperAddress,
    uint64 _subId,
    bytes32 _keyHash
) VRFConsumerBaseV2(_linkAddress) VRFV2WrapperConsumerBase(_linkAddress, _vrfWrapperAddress) {
    // No additional logic required
}
    function flip(CoinFlipSelection choice1) external payable returns (uint256) {
      require(msg.value == entryFees, "Entry fees not sent");
      uint256 requestId = requestRandomness (
        callbackGasLimit,
        requestConfirmations,
        numWords
      );

      statuses[requestId]= CoinFlipStatus ({
        randomWord: 0,
        player: msg.sender,
        didWin: false,
        fulfilled: false, 
        choice: choice1 
      });

      emit CoinFlipRequest(requestId);
      return requestId;
    }

    function fulfillRandomWords(
    uint256 requestId,
    uint256[] memory randomWords
) internal override(VRFConsumerBaseV2, VRFV2WrapperConsumerBase) {
    CoinFlipStatus storage status = statuses[requestId];
    require(status.fulfilled == false, "CoinFlip: Request already fulfilled");

    status.fulfilled = true;
    status.randomWord = randomWords[0];

    CoinFlipSelection result = (randomWords[0] % 2 == 0) ? CoinFlipSelection.TAILS : CoinFlipSelection.HEADS;

    status.didWin = (status.choice == result);
    if (status.didWin) {
        payable(status.player).transfer(entryFees * 2);
    }

    emit CoinFlipResult(requestId, status.didWin);
}

   function rawFulfillRandomWords(uint requestId, uint256[] memory randomWords) public override(VRFConsumerBaseV2, VRFV2WrapperConsumerBase) {
    super.rawFulfillRandomWords(requestId, randomWords);
}

    function getStatus(uint requestId) public view returns(CoinFlipStatus memory){
      return statuses[requestId];
    }
}