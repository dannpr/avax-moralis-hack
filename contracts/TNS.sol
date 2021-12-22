// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.4;

interface TNS {
    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(bytes32 indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(bytes32 indexed node, address resolver);

    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

    event NewRegistration(
        bytes32 indexed label,
        string subdomain,
        address indexed owner,
        address indexed referrer
    );

    function setRecord(
        bytes32 node,
        address _owner,
        address _resolver
    ) external;

    function setOwner(bytes32 node, address _owner) external;

    function owner(bytes32 node) external view returns (address);

    function setResolver(bytes32 node, address _resolver) external;

    function resolver(bytes32 node) external view returns (address);

    function setSubnodeOwner(
        bytes32 node,
        bytes32 label,
        address _owner
    ) external returns (bytes32);

    function setSubnodeRecord(
        bytes32 node,
        bytes32 label,
        address _owner,
        address _resolver
    ) external;
}
