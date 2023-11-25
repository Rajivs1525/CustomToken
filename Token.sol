// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        owner = msg.sender;
        balanceOf[msg.sender] = _totalSupply;
    }
    function transfer(address _to, uint256 _value) external returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        require(_spender != address(0), "Invalid spender address.");
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_from != address(0), "Invalid sender address.");
        require(_to != address(0), "Invalid recipient address.");
        require(_value <= balanceOf[_from], "Insufficient balance.");
        require(_value <= allowances[_from][msg.sender], "Insufficient allowance.");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) external returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance.");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Burn(msg.sender, _value);
        return true;
    }

    function mint(address _to, uint256 _value) external onlyOwner returns (bool) {
        require(_to != address(0), "Invalid recipient address.");

        balanceOf[_to] += _value;
        totalSupply += _value;

        emit Transfer(address(0), _to, _value);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid recipient address.");
        require(_value <= balanceOf[_from], "Insufficient balance.");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
    }
}

