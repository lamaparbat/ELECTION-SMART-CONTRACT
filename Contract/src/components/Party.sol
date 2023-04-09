// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "../common/Structure.sol";

contract Party is Structure{
    
    // Mapping 
    mapping (address => Party) public parties;

    // Arrays
    Party[] public partyList;
    string[] public partyNames;

    // getter functions
    function getAllParties() public view returns (Party[] memory){
        return partyList;
    }

    function getPartyDetails(address owner) public view returns(Party memory){
        return parties[owner];
    }
}