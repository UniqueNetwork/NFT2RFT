// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;
// import "@openzeppelin/contracts/token/ERC721/extensions/IUniqueNFT.sol";
// import './UniqueRFT.sol';
import "./UniqueNFT.sol";
import "./UniqueRFT.sol";
import "./Initializable.sol";

contract NFT2RFT is Initializable {

address[] public wrapped; 
mapping (address => uint)  indexWrapped;
string PREFIXADDR = "0xf8238ccfff8ed887463fd5e0";

  event CreatedWrapping (address);
  function create( 
                address _collection,
                uint256 _tokenId,
                string calldata _wName,
                string calldata _wSymb) public  {
    UniqueNFT nft = UniqueNFT(_collection);
    require(nft.ownerOf(_tokenId) == msg.sender, "Only owner of NFT can wrap it!");

    string memory nameT = string( abi.encodePacked("w", nft.name(), "_",  _wName ));            
    string memory sT = string( abi.encodePacked("w", nft.symbol(), "",  _wSymb ));

    UniqueRFT w =  new  UniqueRFT(nameT, sT, _collection, _tokenId);
    emit CreatedWrapping(address(w));
    }
  
  function getAddress (uint64 _collection, uint64 _token ) internal returns (address addrRFT) {
    addrRFT = address (abi.encodePacked(PREFIXADDR, _collection, _token));
  }

  function wrap (uint256 _totSupply, address _wAddr, address _to) public {
    UniqueRFT w = UniqueRFT(_wAddr);
    w.wrap(_totSupply, _to);
    wrapped.push(address(w));
    indexWrapped[address(w)] = wrapped.length-1;
    
  }

  function unwrap(address _token, address _recepient) public   {
    UniqueRFT(_token).unwrap(_recepient);
    uint curr = indexWrapped[_token];
    uint wrLen = wrapped.length;
    wrapped[curr] = wrapped[wrLen -1];
    delete (wrapped[wrLen -1]);
  }

  function getAllWrapped() public view returns (address[] memory ) {
    return wrapped;
  }

}
