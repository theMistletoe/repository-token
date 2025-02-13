pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "./libs/Killable.sol";
import "./libs/Withdrawable.sol";
import "./Property.sol";
import "./Market.sol";
import "./Metrics.sol";
import "./UseState.sol";
import "./LastAllocationTime.sol";
import "./DevLockUp.sol";

contract Allocator is Killable, Ownable, UseState, Withdrawable {
	using SafeMath for uint256;

	mapping(address => uint256) lastAllocationBlockEachMetrics;
	mapping(address => uint256) lastAllocationValueEachMetrics;
	uint256 public lastTotalAllocationValuePerBlock;

	uint256 public initialPaymentBlock;
	uint256 public lastPaymentBlock;
	uint256 public totalPaymentValue;
	mapping(address => bool) pendingIncrements;
	uint256 public mintPerBlock;
	LastAllocationTime private lastAllocationTime;
	DevLockUp private devLockUp;

	constructor() public {
		lastAllocationTime = new LastAllocationTime();
		devLockUp = new DevLockUp();
	}

	modifier onlyProperty(address _addr) {
		require(
			isProperty(_addr) == true,
			"only Property contract address can be specified"
		);
		_;
	}

	function setSecondsPerBlock(uint256 _sec) public onlyOwner {
		lastAllocationTime.setSecondsPerBlock(_sec);
	}

	function updateAllocateValue(uint256 _value) public {
		address prop = msg.sender;
		require(isProperty(prop), "Is't Property Contract");
		totalPaymentValue += _value;
		uint256 totalPaymentsPerBlock = totalPaymentValue /
			(block.number - initialPaymentBlock);
		uint256 lastPaymentPerBlock = _value /
			(block.number - lastPaymentBlock);
		uint256 acceleration = lastPaymentPerBlock / totalPaymentsPerBlock;
		mintPerBlock = totalPaymentsPerBlock * acceleration;

		if (_value > 0) {
			lastPaymentBlock = block.number;
		}
	}

	function allocate(address _metrics) public payable {
		require(isMetrics(_metrics), "Is't Metrics Contract");
		(uint256 timestamp, uint256 yesterday) = lastAllocationTime
			.getTimeInfo();
		lastAllocationTime.ensureDiffDays(_metrics, yesterday);
		address market = Metrics(_metrics).market();
		pendingIncrements[_metrics] = true;
		Market(market).calculate(
			_metrics,
			lastAllocationTime.getLastAllocationTime(_metrics),
			yesterday
		);
		lastAllocationTime.setLastAllocationTime(_metrics, timestamp);
	}

	function calculatedCallback(address _metrics, uint256 _value) public {
		Metrics metrics = Metrics(_metrics);
		Market market = Market(metrics.market());
		require(
			msg.sender == market.behavior(),
			"Don't call from other than Market Behavior"
		);
		require(
			pendingIncrements[_metrics] == true,
			"Not asking for an indicator"
		);
		address property = metrics.property();
		uint256 share = market.issuedMetrics() / state().totalIssuedMetrics();
		uint256 period = block.number -
			lastAllocationBlockEachMetrics[_metrics];
		uint256 allocationPerBlock = _value / period;
		uint256 nextTotalAllocationValuePerBlock = lastTotalAllocationValuePerBlock -
			lastAllocationValueEachMetrics[_metrics] +
			allocationPerBlock;
		uint256 allocation = allocationPerBlock /
			nextTotalAllocationValuePerBlock *
			mintPerBlock *
			share *
			period;
		lastAllocationBlockEachMetrics[_metrics] = block.number;
		lastAllocationValueEachMetrics[_metrics] = allocationPerBlock;
		lastTotalAllocationValuePerBlock = nextTotalAllocationValuePerBlock;
		increment(property, allocation);
		delete pendingIncrements[_metrics];
	}

	function investToProperty(address _property, uint256 _amount)
		public
		onlyProperty(_property)
	{
		ERC20Burnable(getToken()).burnFrom(msg.sender, _amount);
		increment(_property, _amount);
	}

	function lockUp(address propertyAddress, uint256 amount) public {
		devLockUp.lockUp(propertyAddress, amount);
	}

	function cancel(address propertyAddress) public {
		devLockUp.cancel(propertyAddress);
	}
}
