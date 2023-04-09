// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./Constants.sol";

contract Utils is Constants{
    using SafeMath for uint;
    address public adminAddress;
    uint public totalMaleVoters = 0;
    uint public totalFemaleVoters = 0;
    uint public totalOtherVoters = 0;
    
    constructor(){
        adminAddress = msg.sender;
    }

    function isAdmin(address _id) public view returns (bool){
        return _id == adminAddress;
    }

    modifier isAuthorize(address _adminAddress) {
        require(_adminAddress == adminAddress, "Only admin can invoke this functions !");
        _; // placeholder
    }

    modifier hasValue{
        require(msg.value > 0, "You must send some ether!");
        _;
    }

    function updateCounter(string memory _gender) public {
        if(keccak256(bytes(_gender)) == keccak256(bytes(gender_list[0]))){
            totalMaleVoters = totalMaleVoters.add(1);
        }else if(keccak256(bytes(_gender)) == keccak256(bytes(gender_list[1]))){
            totalFemaleVoters = totalFemaleVoters.add(1);
        }else if(keccak256(bytes(_gender)) == keccak256(bytes(gender_list[2]))){
            totalOtherVoters = totalOtherVoters.add(1);
        }
    }

}