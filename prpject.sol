// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GeographyExplorationGame {
    address public owner;
    uint public totalPlayers;
    mapping(address => uint) public playerScores;
    mapping(uint => string) public countryQuestions;
    mapping(uint => string) public countryAnswers;
    uint public currentQuestionId;
    
    // Event to log player actions
    event GameStarted(uint questionId, string countryName);
    event CorrectAnswer(address player, uint score);
    event IncorrectAnswer(address player);

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
        totalPlayers = 0;
        currentQuestionId = 1;
        // Example questions
        countryQuestions[1] = "What is the capital of France?";
        countryAnswers[1] = "Paris";
    }

    // Function to add a new country question
    function addCountryQuestion(uint questionId, string memory question, string memory answer) public onlyOwner {
        countryQuestions[questionId] = question;
        countryAnswers[questionId] = answer;
    }

    // Function to start the game and display the current question
    function startGame() public view returns (string memory) {
        return countryQuestions[currentQuestionId];
    }

    // Function to submit an answer
    function submitAnswer(string memory answer) public {
        require(bytes(answer).length > 0, "Answer cannot be empty");
        if (keccak256(abi.encodePacked(answer)) == keccak256(abi.encodePacked(countryAnswers[currentQuestionId]))) {
            playerScores[msg.sender] += 1;
            emit CorrectAnswer(msg.sender, playerScores[msg.sender]);
        } else {
            emit IncorrectAnswer(msg.sender);
        }
    }

    // Function to get the player's score
    function getPlayerScore() public view returns (uint) {
        return playerScores[msg.sender];
    }

    // Function to get the total number of players
    function getTotalPlayers() public view returns (uint) {
        return totalPlayers;
    }

    // Function to move to the next question
    function nextQuestion() public onlyOwner {
        currentQuestionId++;
        emit GameStarted(currentQuestionId, countryQuestions[currentQuestionId]);
    }
}
