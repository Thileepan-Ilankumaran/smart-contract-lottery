// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18 ;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";


contract Raffle {
    error Raffle__NotEnoughEthSent();

    /** State Variables **/
    uint16 private constant REQUREST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private i_entranceFee;
    uint256 private immutable i_interval; //duration of lottery in seconds
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gaslane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint256 private immutable s_lastTimeStamp;
    address payable[] private s_players; 
    

    /** Events **/
    event EnterRaffle(address indexed player, uint256 indexed amount);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator, bytes32 gaslane, uint64 subscriptionId, uint32 callbackGasLimit ){
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gaslane = gaslane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        
    }

    function enterRaffle() external payable{
        // require(msg.value>= i_entranceFee, "Not enough ETH sent");    }
        if(msg.value>= i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));

        emit EnterRaffle(msg.sender,msg.value);
    }

    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
    }
    uint256 requestId = i_vrfCoordinator.requestRandomWords(
        i_gaslane,
        i_subscriptionId,
        REQUREST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDS
    );
    }

    /** Getter Function **/

    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }
}