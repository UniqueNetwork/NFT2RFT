//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

//import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
interface iUniqueRFT is IERC20Metadata {
  
  //function setParentNFT (address _parentNFT) internal;
  
  function parentToken() external view returns(address); // _parentToken;
  function parentTokenId() external view returns(uint256); // _parentTokenId;

  //function rePartition(uint32 _numFractions) internal;
  function totalSupply() external view returns (uint) ;

}

