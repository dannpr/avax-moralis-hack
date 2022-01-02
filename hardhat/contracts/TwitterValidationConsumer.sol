pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract TwitterValidationConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    constructor(
        address _oracle,
        bytes32 _jobId,
        uint256 _fee,
        address _link
    ) public {
        if (_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
        oracle = _oracle;
        jobId = _jobId;
        fee = _fee;
    }

    struct Request {
        address claimer;
        bytes32 username;
        uint256 status;
    }

    struct Record {
        address owner;
        address resolver;
    }

    mapping(bytes32 => Request) requests;
    mapping(bytes32 => Record) records;

    event RequestValidationFulfilled(bytes32 indexed requestId, bool indexed validation);

    function requestValidation(string memory _tweetId, string memory _username) public returns (bytes32 requestId) {
        Chainlink.Request memory chainlinkRequest = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillValidation.selector
        );
        chainlinkRequest.add("tweet", _tweetId);
        chainlinkRequest.add("username", _username);
        chainlinkRequest.add("claimer", toAsciiString(msg.sender));

        bytes32 requestId = sendChainlinkRequestTo(oracle, chainlinkRequest, fee);

        Request storage request = requests[requestId];
        request.claimer = msg.sender;
        request.username = stringToBytes32(_username);

        return requestId;
    }

    function fulfillValidation(bytes32 _requestId, bool _validation) public recordChainlinkFulfillment(_requestId) {
        emit RequestValidationFulfilled(_requestId, _validation);

        Request storage request = requests[_requestId];

        if (_validation) {
            Record storage record = records[request.username];
            record.owner = request.claimer;
            record.resolver = msg.sender;
            request.status = 2; // Approved
        } else {
            request.status = 1; // Rejected
        }
    }

    function getRequest(bytes32 _requestId)
        public
        view
        returns (
            address,
            bytes32,
            uint256
        )
    {
        Request storage request = requests[_requestId];
        return (request.claimer, request.username, request.status);
    }

    function getRecord(bytes32 _username) public view returns (address, address) {
        Record storage record = records[_username];
        return (record.owner, record.resolver);
    }

    function getAddress(string memory _username) public view returns (address) {
        return records[stringToBytes32(_username)].owner;
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            // solhint-disable-line no-inline-assembly
            result := mload(add(source, 32))
        }
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
