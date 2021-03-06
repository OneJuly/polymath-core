pragma solidity ^0.4.23;

import "./ISTO.sol";
import "../../interfaces/IST20.sol";


contract DummySTO is ISTO {

    bytes32 public constant ADMIN = "ADMIN";

    uint256 public investorCount;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public cap;
    string public someString;

    event LogGenerateTokens(address _investor, uint256 _amount);

    mapping (address => uint256) public investors;

    constructor (address _securityToken, address _polyAddress) public
    IModule(_securityToken, _polyAddress)
    {
    }

    function configure(uint256 _startTime, uint256 _endTime, uint256 _cap, string _someString) public onlyFactory {
        startTime = _startTime;
        endTime = _endTime;
        cap = _cap;
        someString = _someString;
    }

    function getInitFunction() public returns (bytes4) {
        return bytes4(keccak256("configure(uint256,uint256,uint256,string)"));
    }

    function generateTokens(address _investor, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount should be greater than 0");
        IST20(securityToken).mint(_investor, _amount);
        if (investors[_investor] == 0) {
            investorCount = investorCount + 1;
        }
        //TODO: Add SafeMath maybe
        investors[_investor] = investors[_investor] + _amount;
        emit LogGenerateTokens (_investor, _amount);
    }

    function getRaisedEther() public view returns (uint256) {
        return 0;
    }

    function getRaisedPOLY() public view returns (uint256) {
        return 0;
    }

    function getNumberInvestors() public view returns (uint256) {
        return investorCount;
    }

    function getPermissions() public view returns(bytes32[]) {
        bytes32[] memory allPermissions = new bytes32[](1);
        allPermissions[0] = ADMIN;
        return allPermissions;
    }

}
