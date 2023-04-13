// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./Candidate.sol";

contract Voter is Candidate{
    using SafeMath for uint;

    // Mapping 
    mapping (address => Voter) public voters;

    // Arrays
    Voter[] public voterList;
    string[] public voterNames;

    // counter varirables
    uint public totalVoter = 0;
    uint public voteCount = 0;

    // Event abstractions
    event VoteCast(Candidate candidate);
    event VoterCreated(Voter voter);


    // add new voter
    function addVoter(string memory _name, uint _citizenshipNo, uint _age, string memory _dob,
        string memory _email, string memory _profile,string memory _province,
        string memory _district, string memory _municipality, string memory _ward, string memory _gender
    ) public payable {
        address _id = msg.sender;

        // verify voter if already exist
        if(voters[_id].user.citizenshipNumber != 0){
            revert("Voter already registered !");
        }
        
        updateCounter(_gender);

        address[] memory votedCandidateList;
        Voter memory voter = Voter(
            User(_id, _name, _citizenshipNo, _age, _gender, _dob, _email, _profile, _province, _district, _municipality, _ward), 
            votedCandidateList, 0
        );
        
        voters[_id] = voter;
        voterNames.push(_name);
        voterList.push(voter);
        totalVoter = totalVoter.add(1);

        emit VoterCreated(voter);
    }

    function getAllVoters() public view returns (Voter[] memory){
        return voterList;
    }

    function getVoterDetails(address _id) public view returns(Voter memory){
        return voters[_id];
    }
}
