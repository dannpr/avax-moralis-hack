// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;
/**
 * translate name into address
 * **/
import "./TNS.sol";

/**
 * @dev Provides a default implementation of a resolver for reverse records,
 * which permits only the owner to update it.
 */
contract TNSResolver {
    TNS tns;

    mapping(bytes32 => address) addresses;

    /*     constructor() public {}*/

    function addr(bytes32 node) public view returns (address) {
        return addresses[node];
    }

    function setAddr(bytes32 node, address _addr) public {
        addresses[node] = _addr;
    }
}
