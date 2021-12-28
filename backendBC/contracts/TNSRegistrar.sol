// SPDX-License-Identifier: UNLICENSED

// the registrar is the smart contract that owns a domain
//specify the rules of gouverning the allocations of ttheir subdomains

/**
* .tns is owned by the contract after that when people going to create New
* something.tns the contract going to make the subdomains and transfer the ownership 
**/
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./TNSRegistry.sol";
import "./TNS.sol";
import "./TNSResolver.sol";

contract TNSRegistrar is Ownable, ERC721 {

    event NameRegistered(uint256 indexed id, address indexed owner);

    // TNS registry
    TNS public tns;

    // The namehash of the TLD this registrar owns (eg, .tns)
    bytes32 public baseNode ;// = 0xb3fe6fc506165f2c269c0f1eb203402bf50891554144a08e74c51a08b95e06c3;

    bytes4 constant private INTERFACE_META_ID = bytes4(keccak256("supportsInterface(bytes4)"));

    bytes4 constant private ERC721_ID = bytes4(
        keccak256("balanceOf(address)") ^
        keccak256("ownerOf(uint256)") ^
        keccak256("approve(address,uint256)") ^
        keccak256("getApproved(uint256)") ^
        keccak256("transferFrom(address,address,uint256)") ^
        keccak256("safeTransferFrom(address,address,uint256)") ^
        keccak256("safeTransferFrom(address,address,uint256,bytes)")
        );

    constructor(TNS _tns, bytes32 _baseNode) ERC721("","") {
        tns = _tns;
        baseNode = _baseNode;
    }
    
    function register(uint256 id, address owner) external returns(bytes32) {
        return _register(id,owner,true);
    }

    function _register(uint256 id,address _owner ,bool updateRegistry) internal  returns(bytes32) {

        _mint(_owner, id);
        
        if(updateRegistry) {
            // Get the subdomain so we can configure it
            tns.setSubnodeOwner(baseNode, bytes32(id), _owner);  
        }
        
        emit NameRegistered(id, _owner);

        return bytes32(id);
    }

    /**
     * @dev Gets the owner of the specified token ID. Names become unowned
     *      when their registration expires.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view override(ERC721) returns (address) {
        return super.ownerOf(tokenId);
    }

    function supportsInterface(bytes4 interfaceID) public override pure returns (bool)  {
        return interfaceID == INTERFACE_META_ID ||
               interfaceID == ERC721_ID;
    }

}
