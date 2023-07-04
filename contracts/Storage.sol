//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WagmiTest {
    event sentToContract(address indexed from, address to, uint256 amount);
    event sentFromContract(address indexed from, address to, uint256 amount);

    string public message;
    address public owner;
    mapping(address => uint256) public contractDonators;

    receive() external payable {
        contractDonators[msg.sender] += msg.value;
        emit sentToContract(msg.sender, address(this), msg.value);
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner has access to this");
        _;
    }

    function setMessage(string memory _message) public {
        message = _message;
    }

    function viewMessage() public view returns (string memory) {
        return message;
    }

    function contractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function sendContractBal(address payable addr, uint amount)
        external
        payable
        onlyOwner
    {
        require(address(this).balance > amount, "Low contract balance");
        require(amount <= contractDonators[addr], "Deposited lesser amounts");
        addr.transfer(amount);
        emit sentFromContract(address(this), addr, amount);
    }
}
