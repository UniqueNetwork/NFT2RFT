// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;
// import "@openzeppelin/contracts/token/ERC721/extensions/IUniqueNFT.sol";
// import './UniqueRFT.sol';
import "./UniqueNFT.sol";
import "./iUniqueRFT.sol";
import "./Initializable.sol";

contract NFTRFT is Initializable {


struct NFT {
  address collection;
  uint tokenID;
}
NFT[] public wrappedNFT; 
address[] public indexWrapped;
mapping (address => NFT)  parents; // addressRFT => (address, tokenID) of parent NFT
string PREFIXADDR = "0xf8238ccfff8ed887463fd5e0";

  event CreatedWrapping (address, address, uint128); //parentNFT, RFT, fraction
  event UnWrapped (address, address ); //parentNFT, RFT 
  function nft2rft( 
          address _collection,
          uint256 _tokenID,
          uint64 _partitions) public  {
    UniqueNFT nft = UniqueNFT(_collection);
    require(nft.ownerOf(_tokenID) == msg.sender, "Only owner of NFT can create RFT for it!");

    string memory nameT = string( abi.encodePacked("rft", nft.name()));            
    string memory sT = string( abi.encodePacked("rft", nft.symbol()));

    iUniqueRFT w =  new  iUniqueRFT(nameT, sT, _collection, _tokenID);

    parents[w.address] = NFT(_collection, _tokenID);
    indexWrapped.push(w.address);
    wrappedNFT.push( NFT(_collection, _tokenID));
    emit CreatedWrapping(address(w));
    // rePartition (_partitions);
    }
  
  function getAddress (uint64 _collection, uint64 _token ) internal returns (address addrRFT) {
    addrRFT = address (abi.encodePacked(PREFIXADDR, _collection, _token));
  }
  function unwrap(address _token) public {
    iUniqueRFT thisT = iUniqueRFT(_token);
    require(thisT.balanceOf(msg.Sender) == thisT.totalSupply(), "Needs all totalSupply tokens on msg.Sender's address" );
    NFT memory nftData = parents[_token];
    UniqueNFT nft = UniqueNFT(nftData.collection);
    thisT.burnFrom (msg.Sender, thisT.totalSupply());
    nft.transferFrom(address(this), msg.Sender, nftData.tokenID);
    }

  function rft2nft(address _token) public   {
    unwrap( _token, msg.Sender);
    uint curr = indexWrapped[_token];
    uint wrLen = wrappedNFT.length;
    wrappedNFT[curr] = wrappedNFT[wrLen -1];
    delete (wrappedNFT[wrLen -1]);
  }

  function getAllWrapped() public view returns (address[] memory ) {
    return wrappedNFT;
  }

}
