pragma solidity 0.4.24;

import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/vendor/Ownable.sol";

contract TNSChainlink is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;
    address constant oracle = 0xbC8888Ed3ECaE35bb932D11E17Aca55094b67e0C;
    string constant jobId = "3b93d86cbf8f41a3896cf3fc013f7121";

    struct Request {
        address claimer;
        bytes32 username;
    }
    struct Record {
        address owner;
        address resolver;
    }

    mapping(bytes32 => Request) requests;
    mapping(bytes32 => Record) records;

    event RequestValidationFulfilled(
        bytes32 indexed requestId,
        bytes32 indexed username,
        bytes32 indexed text
    );

    constructor() public Ownable() {
        setChainlinkToken(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
    }

    function requestValidation(string _tweetId, string _username)
        public
        onlyOwner
    {
        Chainlink.Request memory chainlinkRequest = buildChainlinkRequest(
            stringToBytes32(jobId),
            this,
            this.fulfillValidation.selector
        );
        chainlinkRequest.add("tweet", _tweetId); // 1469504391057137664

        sendChainlinkRequestTo(oracle, chainlinkRequest, ORACLE_PAYMENT);

        Request memory request = requests[chainlinkRequest.id];
        request.claimer = msg.sender;
        request.username = stringToBytes32(_username);
    }

    function fulfillValidation(
        bytes32 _requestId,
        bytes32 _username,
        bytes32 _text
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestValidationFulfilled(_requestId, _username, _text);

        Request memory request = requests[_requestId];

        if (
            _username == request.username && address(_text) == request.claimer
        ) {
            Record memory record = records[request.username];
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

    function bytes32ToAddress(bytes32 data) external pure returns (address) {
        return address(data);
    }
}
