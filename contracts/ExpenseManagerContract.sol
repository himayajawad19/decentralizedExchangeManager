// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// Defining the contract -- contract is like a class
contract ExpenseManagerContract {
    address public owner;
    // Define the model
    struct Transaction {
        address user;
        uint amount;
        string reason;
        uint timestamp;
    }
    Transaction[] public transactions;
    constructor() {
        owner = msg.sender;
    }
    mapping(address => uint) public balances;
    event Deposit(
        address indexed _from,
        uint _amount,
        string _reason,
        uint timeStamp
    );
    event Withdraw(
        address indexed _to,
        uint _amount,
        string _reason,
        uint timeStamp
    );
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    function deposit(uint _amount, string memory _reason) public payable {
        require(_amount > 0, "Deposit amount should be greater than 0");
        balances[msg.sender] += _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }

    function withdraw(uint _amount, string memory _reason) public {
        require(balances[msg.sender] >= _amount, "Insufficient Balance");
        balances[msg.sender] -= _amount;
        transactions.push(
            Transaction(msg.sender, _amount, _reason, block.timestamp)
        );
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp);
    }

    function getBalance(address _account) public view returns (uint) {
        return balances[_account];
    }
    function getTransaction() public view returns (uint) {
        return transactions.length;
    }

    function getTransactionCount(
        uint _index
    ) public view returns (address, uint, string memory, uint) {
        require(_index < transactions.length, "Index out of bound");
        Transaction memory transaction = transactions[_index];
        return (
            transaction.user,
            transaction.amount,
            transaction.reason,
            transaction.timestamp
        );
    }
    function getAllTransaction()
        public
        view
        returns (
            address[] memory,
            uint[] memory,
            string[] memory,
            uint[] memory
        )
    {
        address[] memory users = new address[](transactions.length);
        uint[] memory amount = new uint[](transactions.length);
        string[] memory reason = new string[](transactions.length);
        uint[] memory timeStamp = new uint[](transactions.length);
        for (uint i = 0; i <= transactions.length; i++) {
            users[i] = transactions[i].user;
            amount[i] = transactions[i].amount;
            reason[i] = transactions[i].reason;
            timeStamp[i] = transactions[i].timestamp;
        }
        return (users, amount, reason, timeStamp);
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
