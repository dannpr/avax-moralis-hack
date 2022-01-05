// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.4;

import "./TNS.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them, but
 * expires registrations a fixed period after they're initially claimed.
 */
contract TestRegistrar {
    uint256 constant registrationPeriod = 4 weeks;

    TNS public tns;
    bytes32 public rootNode;

    /**
     * Constructor.
     * @param tnsAddr The address of the TNS registry.
     * @param node The node that this registrar administers.
     */
    constructor(TNS tnsAddr, bytes32 node) {
        tns = tnsAddr;
        rootNode = node;
    }

    /**
     * Register a name that's not currently registered
     * @param label The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 label, address owner) public {
        tns.setSubnodeOwner(rootNode, label, owner);
    }
}
