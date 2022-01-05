// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.4;

import "./TNS.sol";
import "./TNSReverseRegistrar.sol";

/**
 * @dev Provides a default implementation of a resolver for reverse records,
 * which permits only the owner to update it.
 */
contract DefaultReverseResolver {
    TNS public tns;
    mapping(bytes32 => string) public name;

    /**
     * @dev Only permits calls by the reverse registrar.
     * @param node The node permission is required for.
     */
    modifier onlyOwner(bytes32 node) {
        require(msg.sender == tns.owner(node));
        _;
    }

    /**
     * @dev Constructor
     * @param ensAddr The address of the ENS registry.
     */
    constructor(TNS ensAddr) {
        tns = ensAddr;

        // Assign ownership of the reverse record to our deployer
        ReverseRegistrar registrar = ReverseRegistrar(
            tns.owner(ADDR_REVERSE_NODE)
        );
        if (address(registrar) != address(0x0)) {
            registrar.claim(msg.sender);
        }
    }

    /**
     * @dev Sets the name for a node.
     * @param node The node to update.
     * @param _name The name to set.
     */
    function setName(bytes32 node, string memory _name) public onlyOwner(node) {
        name[node] = _name;
    }
}
