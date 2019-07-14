pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "./modules/BokkyPooBahsDateTimeLibrary.sol";
import "./libs/UintToString.sol";
import "./libs/StringToUint.sol";
import "./libs/Killable.sol";
import "./libs/Timebased.sol";
import "./libs/Withdrawable.sol";
import "./modules/oraclizeAPI_0.5.sol";
import "./Repository.sol";
import "./UseState.sol";

contract Distributor is
	Timebased,
	Killable,
	Ownable,
	UseState,
	usingOraclize,
	Withdrawable
{
	using SafeMath for uint;
	using UintToString for uint;
	using StringToUint for string;
	uint public mintVolumePerDay;
	uint public totalDownloadsPerDay;
	string public xxxxx;
	struct Request {
		string start;
		string end;
		uint period;
		address invoker;
		address package;
	}
	mapping(address => uint) lastDistributes;
	mapping(address => Request) requests;
	mapping(bytes32 => address) oraclePendingQueries;
	mapping(address => uint) lastDownloads;

	event LogDownloadsUpdated(address _repository, uint _downloads);
	event LogYoutubeViewCount(string views);

	constructor()
        public
    {
        // update(); // Update views on contract creation...
		xxxxx = "kjcsidbiv";
    }

	function setMintVolumePerDay(uint _vol) public onlyOwner {
		mintVolumePerDay = _vol;
	}

	function setSecondsPerBlock(uint _sec) public onlyOwner {
		_setSecondsPerBlock(_sec);
	}

	function dateFormat(uint _y, uint _m, uint _d)
		internal
		pure
		returns (string memory)
	{
		return string(
			abi.encodePacked(
				_y.toString(),
				"-",
				_m.toString(),
				"-",
				_d.toString()
			)
		);
	}

	function distribute(address _repos) public payable {
		require(isRepository(_repos), "Is't Repository Token");
		uint lastDistribute = lastDistributes[_repos] > 0
			? lastDistributes[_repos]
			: baseTime.time;
		uint yesterday = timestamp() - 1 days;
		uint diff = BokkyPooBahsDateTimeLibrary.diffDays(
			lastDistribute,
			yesterday
		);
		require(diff >= 1, "Expected an interval is one day or more");
		(uint startY, uint startM, uint startD) = BokkyPooBahsDateTimeLibrary
			.timestampToDate(lastDistribute);
		(uint endY, uint endM, uint endD) = BokkyPooBahsDateTimeLibrary
			.timestampToDate(yesterday);
		string memory start = dateFormat(startY, startM, startD);
		string memory end = dateFormat(endY, endM, endD);
		requests[_repos] = Request(start, end, diff, msg.sender, _repos);
		oracleQueryNpmDownloads(_repos);
		lastDistributes[_repos] = timestamp();
		msg.sender.transfer(address(this).balance);
	}

	// It is expected to be called by [Oraclize](https://docs.oraclize.it/#ethereum-quick-start).
	// function __callback(bytes32 _id, string memory _result) public {
	// 	Request memory req = requests[oraclePendingQueries[_id]];
	// 	if (msg.sender != oraclize_cbAddress()) {
	// 		revert("mismatch oraclize_cbAddress");
	// 	}
	// 	address repos = req.package;
	// 	require(repos != address(0), "invalid query id");
	// 	uint count = _result.toUint(0);
	// 	emit LogDownloadsUpdated(repos, count);
	// 	uint dailyDownloads = daily(count, req.period);
	// 	uint nextTotalDownloads = totalDownloadsPerDay.sub(
	// 		lastDownloads[repos].add(dailyDownloads)
	// 	);
	// 	uint rate = dailyDownloads.div(nextTotalDownloads);
	// 	uint vol = req.period.mul(mintVolumePerDay);
	// 	uint value = vol.mul(rate);
	// 	increment(repos, value);
	// 	setTotalDownloadsPerDay(nextTotalDownloads);
	// }

	function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == oraclize_cbAddress());
        // viewsCount = _result;
		// setMintVolumePerDay(_result);
		xxxxx = _result;
        emit LogYoutubeViewCount(xxxxx);
        // Do something with viewsCount, like tipping the author if viewsCount > X?
    }

	function daily(uint _downloads, uint _period) internal pure returns (uint) {
		return _downloads.div(_period);
	}

	function setTotalDownloadsPerDay(uint _d) internal {
		totalDownloadsPerDay = _d;
	}

	function oracleQueryNpmDownloads(address _reqrepos) public payable {
		require(
			oraclize_getPrice("URL") > address(this).balance,
			"Oraclize query was NOT sent, please add some ETH to cover for the query fee"
		);
		Request memory req = requests[_reqrepos];
		string memory package = Repository(req.package).package();
		string memory url = string(
			abi.encodePacked(
				"https://api.npmjs.org/downloads/point/",
				req.start,
				":",
				req.end,
				"/",
				package
			)
		);
		string memory param = string(
			abi.encodePacked("json(", url, ").downloads")
		);
		bytes32 queryId = oraclize_query("URL", param);
		oraclePendingQueries[queryId] = _reqrepos;
	}

	function update()
        public
        payable
    {
        // emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
        // oraclize_query("URL", 'html(https://www.youtube.com/watch?v=9bZkp7q19f0).xpath(//*[contains(@class, "watch-view-count")]/text())');
        // oraclize_query("URL", 'json(https://api.github.com/users/theMistletoe).login');
        oraclize_query("URL", 'json(https://api.npmjs.org/downloads/point/2019-07-01:2019-07-02/yarn).downloads');
		setMintVolumePerDay(2938);
    }
}
