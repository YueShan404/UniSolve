// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UniSolve {
    
    struct Question {
        uint256 id;
        address asker;
        string title;
        string contentPreview;
        uint256 bounty;
        uint256 deadline;
        bool isActive;
        bool isResolved;
        address winner;
    }
    
    struct Answer {
        uint256 id;
        uint256 questionId;
        address solver;
        string preview;
        string encryptedFull;
        string proof;
        uint256 price;
        uint256 timestamp;
        bool isPaid;
        address paidBy;
        string decryptionKey;
    }
    
    mapping(uint256 => Question) public questions;
    mapping(uint256 => Answer[]) public answers;
    
    uint256 public questionCounter;
    uint256 public answerCounter;
    
    event QuestionCreated(uint256 id, address asker, string title, uint256 bounty);
    event AnswerSubmitted(uint256 questionId, uint256 answerId, address solver, string preview);
    event AnswerPurchased(uint256 questionId, uint256 answerId, address buyer, address solver, uint256 price);
    event WinnerSelected(uint256 questionId, address winner, uint256 price);
    event QuestionRefunded(uint256 questionId, address asker);
    
    // 1. Create question with bounty
    function createQuestion(
        string memory _title,
        string memory _contentPreview,
        uint256 _bounty,
        uint256 _durationMinutes
    ) external payable {
        require(msg.value >= _bounty, "Must send at least bounty amount");
        require(_bounty > 0, "Bounty must be greater than 0");
        
        uint256 questionId = questionCounter;
        questionCounter++;
        
        questions[questionId] = Question({
            id: questionId,
            asker: msg.sender,
            title: _title,
            contentPreview: _contentPreview,
            bounty: _bounty,
            deadline: block.timestamp + (_durationMinutes * 60),
            isActive: true,
            isResolved: false,
            winner: address(0)
        });
        
        emit QuestionCreated(questionId, msg.sender, _title, _bounty);
    }
    
    // 2. Submit answer with preview + encrypted full
    function submitAnswer(
        uint256 _questionId,
        string memory _preview,
        string memory _encryptedFull,
        string memory _proof,
        uint256 _price
    ) external {
        Question storage q = questions[_questionId];
        require(q.isActive, "Question not active");
        require(!q.isResolved, "Already resolved");
        require(block.timestamp < q.deadline, "Deadline passed");
        require(_price <= q.bounty, "Price cannot exceed bounty");
        require(bytes(_preview).length > 0, "Preview cannot be empty");
        
        uint256 answerId = answerCounter;
        answerCounter++;
        
        Answer memory newAnswer = Answer({
            id: answerId,
            questionId: _questionId,
            solver: msg.sender,
            preview: _preview,
            encryptedFull: _encryptedFull,
            proof: _proof,
            price: _price,
            timestamp: block.timestamp,
            isPaid: false,
            paidBy: address(0),
            decryptionKey: ""
        });
        
        answers[_questionId].push(newAnswer);
        
        emit AnswerSubmitted(_questionId, answerId, msg.sender, _preview);
    }
    
    // 3. Purchase answer (pay to unlock full content)
    function purchaseAnswer(uint256 _questionId, uint256 _answerId) external payable {
        Question storage q = questions[_questionId];
        Answer storage a = answers[_questionId][_answerId];
        
        require(msg.sender == q.asker, "Only asker can purchase");
        require(q.isActive, "Question not active");
        require(!q.isResolved, "Already resolved");
        require(!a.isPaid, "Answer already purchased");
        require(msg.value >= a.price, "Insufficient payment");
        
        a.isPaid = true;
        a.paidBy = msg.sender;
        
        payable(a.solver).transfer(msg.value);
        
        emit AnswerPurchased(_questionId, _answerId, msg.sender, a.solver, msg.value);
    }
    
    // 4. Set decryption key after purchase
    function setDecryptionKey(uint256 _questionId, uint256 _answerId, string memory _key) external {
        Answer storage a = answers[_questionId][_answerId];
        require(msg.sender == a.solver, "Only solver");
        require(a.isPaid, "Answer not purchased yet");
        
        a.decryptionKey = _key;
    }
    
    // 5. Select winner and close question (refund remaining)
    function selectWinner(uint256 _questionId, uint256 _answerId) external {
        Question storage q = questions[_questionId];
        Answer storage a = answers[_questionId][_answerId];
        
        require(msg.sender == q.asker, "Only asker");
        require(q.isActive, "Question not active");
        require(!q.isResolved, "Already resolved");
        require(a.isPaid, "Answer must be purchased first");
        
        q.isResolved = true;
        q.isActive = false;
        q.winner = a.solver;
        
        uint256 remaining = q.bounty - a.price;
        if (remaining > 0) {
            payable(q.asker).transfer(remaining);
        }
        
        emit WinnerSelected(_questionId, a.solver, a.price);
    }
    
    // 6. Auto refund if no answer purchased
    function refundTimeout(uint256 _questionId) external {
        Question storage q = questions[_questionId];
        require(q.isActive, "Not active");
        require(!q.isResolved, "Already resolved");
        require(block.timestamp >= q.deadline, "Deadline not passed");
        
        q.isActive = false;
        q.isResolved = true;
        
        payable(q.asker).transfer(q.bounty);
        
        emit QuestionRefunded(_questionId, q.asker);
    }
    
    // ----- VIEW FUNCTIONS -----
    
    function getQuestion(uint256 _questionId) external view returns (
        address asker,
        string memory title,
        string memory contentPreview,
        uint256 bounty,
        uint256 deadline,
        bool isActive,
        bool isResolved,
        address winner
    ) {
        Question storage q = questions[_questionId];
        return (
            q.asker,
            q.title,
            q.contentPreview,
            q.bounty,
            q.deadline,
            q.isActive,
            q.isResolved,
            q.winner
        );
    }
    
    function getAnswers(uint256 _questionId) external view returns (Answer[] memory) {
        return answers[_questionId];
    }
    
    function getAnswerPreview(uint256 _questionId, uint256 _answerId) external view returns (string memory) {
        return answers[_questionId][_answerId].preview;
    }
    
    function getDecryptionKey(uint256 _questionId, uint256 _answerId) external view returns (string memory) {
        Answer storage a = answers[_questionId][_answerId];
        require(msg.sender == a.paidBy || msg.sender == a.solver, "Not authorized");
        return a.decryptionKey;
    }
    
    function hasPurchased(uint256 _questionId, uint256 _answerId, address _user) external view returns (bool) {
        Answer storage a = answers[_questionId][_answerId];
        return a.paidBy == _user;
    }
    
    function getQuestionCount() external view returns (uint256) {
        return questionCounter;
    }
    
    function getActiveQuestions() external view returns (uint256[] memory) {
        uint256[] memory activeIds = new uint256[](questionCounter);
        uint256 count = 0;
        for (uint i = 0; i < questionCounter; i++) {
            if (questions[i].isActive && !questions[i].isResolved) {
                activeIds[count] = i;
                count++;
            }
        }
        // Resize array
        uint256[] memory result = new uint256[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = activeIds[i];
        }
        return result;
    }
}
