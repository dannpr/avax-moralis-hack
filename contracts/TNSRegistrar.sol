// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

// the registrar is the smart contract that owns a domain

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./TNSRegistry.sol";
import "./TNS.sol";
import "./TNSResolver.sol";

contract TNSRegistrar is Ownable, ERC721 {
    // TNS registry
    TNS public tns;

    // The namehash of the TLD this registrar owns (eg, .eth)
    bytes32 public baseNode =
        0xb3fe6fc506165f2c269c0f1eb203402bf50891554144a08e74c51a08b95e06c3;

    // A map of addresses that are authorised to register and renew names.
    mapping(address => bool) public controllers;

    bytes4 private constant INTERFACE_META_ID =
        bytes4(keccak256("supportsInterface(bytes4)"));
    bytes4 private constant ERC721_ID =
        bytes4(
            keccak256("balanceOf(address)") ^
                keccak256("ownerOf(uint256)") ^
                keccak256("approve(address,uint256)") ^
                keccak256("getApproved(uint256)") ^
                keccak256("transferFrom(address,address,uint256)") ^
                keccak256("safeTransferFrom(address,address,uint256)") ^
                keccak256("safeTransferFrom(address,address,uint256,bytes)")
        );
    bytes4 private constant RECLAIM_ID =
        bytes4(keccak256("reclaim(uint256,address)"));

    address public registrarOwner;
    address public registrar;

    /**
     * @dev Returns whether the given spender can transfer a given token ID
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     *    is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        override
        returns (bool)
    {
        address owner = ownerOf(tokenId);
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    constructor(TNS _tns) ERC721("", "") {
        tns = _tns;
        registrar = tns.owner(baseNode);
        registrarOwner = msg.sender;
    }

    /**
     * @dev Gets the owner of the specified token ID. Names become unowned
     *      when their registration expires.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (address)
    {
        return super.ownerOf(tokenId);
    }

    function doRegistration(
        uint256 id,
        bytes32 node,
        bytes32 label,
        address subdomainOwner,
        TNSResolver resolver,
        bool updateRegistry
    ) internal {
        if (_exists(id)) {
            // Name was previously owned, and expired
            _burn(id);
        }

        _mint(subdomainOwner, id);

        if (updateRegistry) {
            // Get the subdomain so we can configure it
            tns.setSubnodeOwner(node, label, address(this));

            bytes32 subnode = keccak256(abi.encodePacked(node, label));

            // Set the subdomain's resolver
            tns.setResolver(subnode, address(resolver));

            // Set the address record on the resolver
            resolver.setAddr(subnode, subdomainOwner);

            // Pass ownership of the new subdomain to the registrant
            tns.setOwner(subnode, subdomainOwner);
        }
    }

    function supportsInterface(bytes4 interfaceID)
        public
        pure
        override
        returns (bool)
    {
        return
            interfaceID == INTERFACE_META_ID ||
            interfaceID == ERC721_ID ||
            interfaceID == RECLAIM_ID;
    }

    /**
     * @dev Sets the resolver record for a name in TNS.
     * @param name The name to set the resolver for.
     * @param resolver The address of the resolver
     */
    function setResolver(string memory name, address resolver) public {
        bytes32 label = keccak256(bytes(name));
        bytes32 node = keccak256(abi.encodePacked(baseNode, label));
        tns.setResolver(node, resolver);
    }
}
