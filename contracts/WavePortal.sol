// SPDX-License-Identifier: UNLICENSED
// 0x5FbDB2315678afecb367f032d93F642f64180aa3 localhost
// 0x806765197e2A0685f0Fc88DB464119d458B93Ff4 rinkeby
// 0xa8cd2882c1445b0412eA9c966ff9c9Db179E165B rinkeby 2
// 0xF907F9F335e6A50150666CE28C61193e26A71118 rinkeby 3
// 0xB4ee86A4247fE409cf0D2f777FF691779D74A520 rinkeby 4

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal{
  uint256 totalWaves;
  uint256 private seed;

  event NewWave(address indexed from, uint256 timestamp, string message);

  struct Wave{
    address waver;
    string message;
    uint256 timestamp;
  }

  Wave[] waves;

  mapping(address => uint256) public lastWavedAt;

  constructor() payable{
    console.log("I AM SMART CONTRACT. POG.");
    seed = (block.timestamp + block.difficulty) % 100;
  }

  function wave(string memory _message) public{
    require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15m");

    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves += 1;

    console.log("%s waved w/ message %s", msg.sender, _message);
    waves.push(Wave(msg.sender, _message, block.timestamp));
    seed = (block.timestamp + block.difficulty) % 100;
    console.log("Random # generated: %d", seed);
    if (seed <= 50){
      console.log("%s won", msg.sender);
      uint256 prizeAmount = 0.0001 ether;
      require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");
      (bool success,) = (msg.sender).call{value: prizeAmount}("");
      require(success, "Failed to withdraw money from contract.");
    }
    emit NewWave(msg.sender, block.timestamp, _message);
  }

  function getAllWaves() public view returns (Wave[] memory) {
    return waves;
  }

  function getTotalWaves() public view returns (uint256){
    return totalWaves;
  }
}
