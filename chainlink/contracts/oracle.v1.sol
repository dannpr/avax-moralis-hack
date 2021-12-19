pragma solidity 0.4.24;

import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/vendor/Ownable.sol";

contract TNSChainlink is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;
    bytes public tweet;
    address oracle = 0xbC8888Ed3ECaE35bb932D11E17Aca55094b67e0C;
    string jobId = "dde7aecd41224036bc2cf48d8b0d21a3";

    struct Request {
        address claimer;
        string username;
    }
    struct Record {
        address owner;
        address resolver;
    }

    mapping(bytes32 => Request) requests;
    mapping(bytes32 => Record) records;

    event RequestTweetFulfilled(bytes32 indexed requestId, bytes indexed tweet);

    constructor() public Ownable() {
        setChainlinkToken(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
    }

    function requestTweet(string _tweetId, string _username) public onlyOwner {
        Chainlink.Request memory chainlinkRequest = buildChainlinkRequest(
            stringToBytes32(jobId),
            this,
            this.fulfillTweet.selector
        );
        chainlinkRequest.add("tweet", _tweetId); //"1469504391057137664");
        chainlinkRequest.add("username", _username);

        sendChainlinkRequestTo(oracle, chainlinkRequest, ORACLE_PAYMENT);

        Request memory request = requests[chainlinkRequest.id];
        request.claimer = msg.sender;
        request.username = _username;
    }

    function fulfillTweet(bytes32 _requestId, bytes _tweet)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestTweetFulfilled(_requestId, _tweet);
        tweet = _tweet;

        Request memory request = requests[_requestId];
        bytes memory claimer = toBytes(request.claimer);
        bytes32 username = stringToBytes32(request.username);
        bool validated = username.length + 42 == _tweet.length;

        if (validated) {
            for (uint256 i = 0; i <= _tweet.length; i++) {
                if (
                    (i < username.length && username[i] != _tweet[i]) ||
                    (i >= username.length &&
                        claimer[i - username.length] != _tweet[i])
                ) {
                    validated = false;
                    break;
                }
            }
        }

        if (validated) {
            Record memory record = records[username];
            record.owner = request.claimer;
            record.resolver = msg.sender;
        }
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function stringToBytes32(string memory source)
        private
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }

    function addressToString(address _address)
        public
        pure
        returns (string memory _uintAsString)
    {
        uint256 _i = uint256(_address);
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    function toBytes(address a) public pure returns (bytes memory b) {
        return abi.encodePacked(a);
    }
}
