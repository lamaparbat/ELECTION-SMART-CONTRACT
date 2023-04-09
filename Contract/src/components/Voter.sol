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
    
    // caste vote
    function vote(address _candidateId) public payable{
        address _voterId = msg.sender;

        // restrict admin for vote casting
        if(_voterId == adminAddress){
            revert("Admin is restrict to caste vote.");
        }

        // verify vote limit count
        if(voters[_voterId].voteLimitCount > 3){
            revert("You have exceed the vote caste limit.");
        }

        candidates[_candidateId].votedVoterLists.push(_voterId);
        voters[_voterId].votedCandidateList.push(_candidateId);
        candidates[_candidateId].voteCount = candidates[_candidateId].voteCount.add(1);
        voteCount = voteCount.add(1); 

        for(uint i=0;i<candidateList.length;i++){
            if(candidateList[i].user._id == _candidateId){
                candidateList[i].votedVoterLists.push(_voterId);
            }
        }

        for(uint i=0;i<voterList.length;i++){
            if(voterList[i].user._id == _voterId){
                voterList[i].votedCandidateList.push(_candidateId);
            }
        }

        voters[_voterId].voteLimitCount = voters[_voterId].voteLimitCount.add(1);
        

        emit VoteCast(candidates[_candidateId]);
    }


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
