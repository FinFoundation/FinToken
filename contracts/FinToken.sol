pragma solidity ^0.4.18;
import './zeppelin/token/PausableToken.sol';

contract FinToken is PausableToken {

    string  public  constant name = "Fuel Injection Network";
    string  public  constant symbol = "FIN";
    uint8   public  constant decimals = 18;

    mapping(address => uint) approvedInvestorListWithDate;

    function FinToken( address _admin, uint256 _totalTokenAmount )
    {
        admin = _admin;

        totalSupply = _totalTokenAmount;
        balances[msg.sender] = _totalTokenAmount;
        Transfer(address(0x0), msg.sender, _totalTokenAmount);
    }

    function getTime() public constant returns (uint) {
        return now;
    }

    function isUnlocked() internal view returns (bool) {
        return getTime() >= getLockFundsReleaseTime(msg.sender);
    }

    modifier validDestination( address to )
    {
        require(to != address(0x0));
        require(to != address(this));
        _;
    }

    modifier onlyWhenUnlocked()
    {
        require(isUnlocked());            
        _;
    }

    function transfer(address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
    {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
    {
        require(getTime() >= getLockFundsReleaseTime(_from));
        return super.transferFrom(_from, _to, _value);
    }

    function getLockFundsReleaseTime(address _addr) public view returns(uint) 
    {
        return approvedInvestorListWithDate[_addr];
    }

    function setLockFunds(address[] newInvestorList, uint releaseTime) onlyOwner public 
    {
        require(releaseTime > getTime());
        for (uint i = 0; i < newInvestorList.length; i++)
        {
            approvedInvestorListWithDate[newInvestorList[i]] = releaseTime;
        }
    }

    function removeLockFunds(address[] investorList) onlyOwner public 
    {
        for (uint i = 0; i < investorList.length; i++)
        {
            approvedInvestorListWithDate[investorList[i]] = 0;
            delete(approvedInvestorListWithDate[investorList[i]]);
        }
    }

    function setLockFund(address newInvestor, uint releaseTime) onlyOwner public 
    {
        require(releaseTime > getTime());
        approvedInvestorListWithDate[newInvestor] = releaseTime;
    }


    function removeLockFund(address investor) onlyOwner public 
    {
        approvedInvestorListWithDate[investor] = 0;
        delete(approvedInvestorListWithDate[investor]);
    }


    event Burn(address indexed _burner, uint256 _value);

    function burn(uint256 _value) onlyOwner public returns (bool)
    {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(msg.sender, _value);
        Transfer(msg.sender, address(0x0), _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool)
    {
        assert( transferFrom( _from, msg.sender, _value ) );
        return burn(_value);
    }

    function emergencyERC20Drain( ERC20 token, uint256 amount ) onlyOwner {
        token.transfer( owner, amount );
    }

    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    function changeAdmin(address newAdmin) onlyOwner {
        AdminTransferred(admin, newAdmin);
        admin = newAdmin;
    }

    function () public payable 
    {
        revert();
    }
}