// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "./src/components/Candidate.sol";
import "./src/components/Voter.sol";
import "./src/components/Party.sol";

contract Election is Candidate, Voter, Party{
    using SafeMath for uint;
    
    // Mapping 
    mapping (string => Election) public elections;
    mapping (address => FAQ) public faqs;

    // Arrays
    Election[] public electionList;
    FAQ[] public faqList;


    // counter varirables
    uint public totalParty = 0;
    uint public totalElection = 0;

    // Event abstractions
    event PartyCreated(Party party);
    event electionStart(Election election);
    event NewFaqAdded(FAQ faq);

    // setter functions
    function addParty(string memory _name, uint _totalMember, string memory _agenda, string memory _logoUrl) public payable isAuthorize(msg.sender) {
        address[] memory emptyArray;
        Party memory party = Party(adminAddress, _name, _totalMember, _agenda, _logoUrl, emptyArray);
        
        parties[adminAddress] = party;
        partyNames.push(_name);
        partyList.push(party);
        totalParty = totalParty.add(1);

        emit PartyCreated(party);
    }

    function createElection( 
        string memory _title,
        string memory _description,
        string memory _startDate,
        string memory _endDate,
        string memory _electionType,
        string[] memory galleryImagesUrl
    ) public payable isAuthorize(msg.sender){
        address[] memory selectedCandidates;
        Election memory election = Election(_title, _description, _startDate, _endDate, _electionType, selectedCandidates, galleryImagesUrl);

        elections[_startDate] = election;
        electionList.push(election);
        totalElection = totalElection.add(1);

        emit electionStart(election);
    }

    function addSelectedCandidates(
        address[] memory _selectedCandidates,
        string memory electionAddress
    ) public payable isAuthorize(msg.sender){
        for (uint i = 0; i < _selectedCandidates.length; i++) {
            elections[electionAddress].selectedCandidates.push(_selectedCandidates[i]);
        }

        for(uint i = 0; i < electionList.length; i++){
            if(keccak256(bytes(electionList[i].startDate)) == keccak256(bytes(electionAddress))){
                for (uint j = 0; j < _selectedCandidates.length; j++) {
                    electionList[i].selectedCandidates.push(_selectedCandidates[j]);
                }
                break;
            }
        }
    }

    function addFaqs(string memory title, string memory description, string memory fileUrl, string memory createdAt) public payable{
        address _id = msg.sender;
        ReplyComment[] memory replies;

        FAQ memory faq = FAQ(_id, title, description, fileUrl, createdAt, replies);
        faqs[_id] =faq;
        faqList.push(faq);
    }

    function addFaqComment(address faqId, string memory replyMsg, string memory createdAt) public payable{
        address _id = msg.sender;
        ReplyComment memory reply = ReplyComment(_id, replyMsg, createdAt);

        faqs[faqId].comments.push(reply);

        for(uint i=0;i<faqList.length;i++){
            if(faqList[i]._id == faqId){
                faqList[i].comments.push(reply);
                break;
            }
        }
    }

    function getAllElections() public view returns (Election[] memory){
        return electionList;
    }

    function getAllFAQs() public view returns (FAQ[] memory) {
        return faqList;
    }
}




// test data
// Parbat, 0778, 22, wanna make secure system, sep 12 2022, kathamandu nepal, parbat@gmail.com, http://profile.com, Congress
// Gaurab, 0778, 22, oct 11 2022, garuab@gmail.com, http://profile.com, madhesh ,sarlahi,barahathawa, 9 


// create election
// Election 2022, hello world election, sep 12 2022 , sep 13 2022, province

// add faq & reply
// UI design issues, please maintain your desing, https://file.png, 2023-23-23T1-23-12
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, yes it caused problem, 2023-34-23T2-34-23
