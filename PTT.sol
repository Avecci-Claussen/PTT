// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NonTransferableOwnable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }
}

contract PayToTell is ERC20, NonTransferableOwnable {
    constructor(uint256 initialSupply) ERC20("Pay To Tell", "PTT") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferWithDescription(address to, uint256 amount, string memory description) public returns (bool) {
        bool success = transfer(to, amount);
        require(success, "Transfer failed");
        emit TransferWithDescription(msg.sender, to, amount, description);
        return true;
    }

    event TransferWithDescription(address indexed from, address indexed to, uint256 value, string description);
}

contract MyPaymentContract is NonTransferableOwnable {
    PayToTell public token;
    uint256 public constant PRICE_PER_TOKEN = 100; // For 1 Matic, you'd get 100 PTT tokens

    event PaymentMade(address indexed from, address indexed to, uint256 amount, string description);
    event Error(address indexed from, string reason);
    event TokensBought(address indexed buyer, uint256 amount);

    constructor(address _token) {
        token = PayToTell(_token);
        token.mint(address(this), 1000 * 10**18); // Mint 1000 PTT to this contract
    }

    function makePayment(address _to, uint256 _amount, string memory _description) public {
        uint256 senderBalance = token.balanceOf(msg.sender);
        require(senderBalance >= _amount, "Not enough tokens");

        bool success = token.transferFrom(msg.sender, _to, _amount);
        require(success, "Transfer failed");

        emit PaymentMade(msg.sender, _to, _amount, _description);
    }

    function buyToken() public payable {
        uint256 tokensToBuy = msg.value * PRICE_PER_TOKEN;
        require(tokensToBuy >= 10**16, "Minimum purchase is 0.01 PTT");

        uint256 tokenBalance = token.balanceOf(address(this));
        require(tokenBalance >= tokensToBuy, "Not enough tokens in contract");

        bool success = token.transfer(msg.sender, tokensToBuy);
        require(success, "Purchase failed");

        emit TokensBought(msg.sender, tokensToBuy);
    }

    function withdraw() external onlyOwner {
        (bool success,) = owner().call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
