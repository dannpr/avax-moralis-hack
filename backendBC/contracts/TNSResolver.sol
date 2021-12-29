// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;
/**
 * permit to find directly what we search in the tns
 * Resolvers are responsible for performing resource lookups for a name - for instance, returning a contract address, a content hash, or IP address(es) as appropriate.
 * The resolver specification, defined here and extended in other ENSIPs, defines what methods a resolver may implement to support resolving different types of records.
 */

/**
 * translate name into address
 * **/
import "./TNS.sol";

/**
 * @dev Provides a default implementation of a resolver for reverse records,
 * which permits only the owner to update it.
 * translate name into address
 */
contract TNSResolver {
    TNS tns;

    mapping(bytes32 => address) addresses;

    function addr(bytes32 node) public view returns (address) {
        return addresses[node];
    }

    function setAddr(bytes32 node, address _addr) public {
        addresses[node] = _addr;
    }
}
