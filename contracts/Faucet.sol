// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IERC20 {
    function transfer(address to, uint256 amount) external view returns (bool);

    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable public owner;
    uint256 public withdrawAmount = 10 * (10**18);
    uint256 public lockTime = 2 minutes;

    event Withdraw(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);
    mapping(address => uint256) nextAccessTime;

    IERC20 public token;

    constructor(address payable tokenAddress) {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestTokens() public {
        require(
            msg.sender != address(0),
            "request must oringinate from a zero account"
        );
        require(
            token.balanceOf(address(this)) >= withdrawAmount,
            "Insufficient balance in Faucet for withdrawal"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient Time lapse since last withdrawal"
        );
        nextAccessTime[msg.sender] = block.timestamp + lockTime;
        token.transfer(msg.sender, withdrawAmount);
    }

    function recieve() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawAmount(uint256 amount) public onlyOwner {
        withdrawAmount = amount * (10**18);
    }

    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 2 minutes;
    }

    function withdraw() external onlyOwner {
        emit Withdraw(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only the contract owner call this function"
        );
        _;
    }
}
