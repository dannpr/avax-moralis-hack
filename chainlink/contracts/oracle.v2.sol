pragma solidity 0.4.24;

import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/contracts/src/v0.4/vendor/Ownable.sol";

contract TNSChainlink is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 1 * LINK;
    address constant oracle = 0xbC8888Ed3ECaE35bb932D11E17Aca55094b67e0C;
    string constant jobId = "05e80dddb64f4978b35b785179d1b23d";

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
        bool indexed validation
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
        chainlinkRequest.add("username", _username); // patriciobcs
        chainlinkRequest.add("claimer", addressToString(msg.sender));

        sendChainlinkRequestTo(oracle, chainlinkRequest, ORACLE_PAYMENT);

        Request memory request = requests[chainlinkRequest.id];
        request.claimer = msg.sender;
        request.username = stringToBytes32(_username);
    }

    function fulfillValidation(bytes32 _requestId, bool _validation)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestValidationFulfilled(_requestId, _validation);

        if (_validation) {
            Request memory request = requests[_requestId];
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
}
