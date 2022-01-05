// SPDX-License-Identifier: UNLICENSED

/**
 * smart contract that maintains domains , store : the owner and the resolver
 * the owner of a domains is either a smart contrac or a user - a owner can transfer ownership set a resolver
 * the resolver : contract that maps from  to ressource , resolver or in the resolver field of registry
 *
 **/
pragma solidity >=0.8.4;
import "./TNS.sol";

/**
 * The TNS registry contract.
 */
contract TNSRegistry is TNS {
    struct Record {
        address owner;
        address resolver;
    }

    mapping(bytes32 => Record) records;

    /**
     * @dev Constructs a new TNS registrar.
     */
    constructor() {
        records[0x0].owner = msg.sender;
    }

    /**
     * @dev Sets the record for a node.
     * @param node The node to update.
     * @param _owner The address of the new owner.
     * @param _resolver The address of the resolver.
     */
    function setRecord(
        bytes32 node,
        address _owner,
        address _resolver
    ) external virtual override {
        setOwner(node, _owner);
        _setResolver(node, _resolver);
    }

    /**
     * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
     * @param node The node to transfer ownership of.
     * @param _owner The address of the new owner.
     */
    function setOwner(bytes32 node, address _owner)
        public
        virtual
        override
    /**authorised(node)**/
    {
        _setOwner(node, _owner);
        emit Transfer(node, _owner);
    }

    /**
     * @dev Returns the address that owns the specified node.
     * @param node The specified node.
     * @return address of the owner.
     */
    function owner(bytes32 node)
        public
        view
        virtual
        override
        returns (address)
    {
        address addr = records[node].owner;
        if (addr == address(this)) {
            return address(0x0);
        }

        return addr;
    }

    /**
     * @dev Sets the resolver address for the specified node.
     * @param node The node to update.
     * @param _resolver The address of the resolver.
     */
    function setResolver(bytes32 node, address _resolver)
        public
        virtual
        override
    {
        emit NewResolver(node, _resolver);
        records[node].resolver = _resolver;
    }

    /**
     * @dev Sets the record for a subnode.
     * @param node The parent node.
     * @param label The hash of the label specifying the subnode.
     * @param _owner The address of the new owner.
     * @param _resolver The address of the resolver.
     */
    function setSubnodeRecord(
        bytes32 node,
        bytes32 label,
        address _owner,
        address _resolver
    ) external virtual override {
        bytes32 subnode = setSubnodeOwner(node, label, _owner);
        _setResolver(subnode, _resolver);
    }

    /**
     * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
     * @param node The parent node.
     * @param label The hash of the label specifying the subnode.
     * @param _owner The address of the new owner.
     */
    function setSubnodeOwner(
        bytes32 node,
        bytes32 label,
        address _owner
    ) public virtual override returns (bytes32) {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        _setOwner(subnode, _owner);
        emit NewOwner(node, label, _owner);
        return subnode;
    }

    function _setResolver(bytes32 node, address _resolver) internal {
        if (_resolver != records[node].resolver) {
            records[node].resolver = _resolver;
            setResolver(node, _resolver);
        }
    }

    function _setOwner(bytes32 node, address _owner) internal virtual {
        records[node].owner = _owner;
    }

    /**
     * @dev Returns the address of the resolver for the specified node.
     * @param node The specified node.
     * @return address of the resolver.
     */
    function resolver(bytes32 node)
        public
        view
        virtual
        override
        returns (address)
    {
        return records[node].resolver;
    }
}
