//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

//import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./UniqueNFT.sol";

contract UniqueRFT is ERC20Burnable, UniqueNFT {
    address public collection;
    uint256 public tokenID;
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;


  constructor ( string memory _name, string memory _symbol,  address _collection, uint256 _tokenID) 
      ERC20( _name, _symbol) {
      collection = _collection;
      tokenID = _tokenID;
    }

    function wrap(uint256 _totSupply,
                address _sender ) public {
        UniqueNFT nft = UniqueNFT(collection);
        require(nft.ownerOf(tokenID) == _sender, "Not owner of NFT");
        nft.transferFrom(_sender, address(this), tokenID);
        _mint(_sender, _totSupply);
  
      }

    function unwrap(address _recepient) public {
        ERC20Burnable thisT = ERC20Burnable(address(this));
        require(thisT.balanceOf(_recepient) == thisT.totalSupply(), "Needs all totalSupply tokens on _recepient's address" );
        UniqueNFT nft = UniqueNFT(collection);
        thisT.burnFrom (_recepient, thisT.totalSupply());
        nft.transferFrom(address(this), _recepient, tokenID);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory ) {
        return UniqueNFT(collection).tokenURI(tokenID);
    }



    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)  public override pure returns(bytes4) {
            return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
        }
    
    
/*     function approve
    function balanceOf
    function burn
    function burnFrom
    function name
    function symbol
    function totalSupply
    function transfer
    function transferFrom */
    function burn(uint256 amount) public virtual override (ERC20Burnable, ERC721Burnable) {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) public virtual override (ERC20Burnable, ERC721UniqueExtensions)  {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
    
       /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override  (ERC20, ERC721Metadata) returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override (ERC20, ERC721Metadata)  returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override (ERC20, ERC721Enumerable) returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override (ERC20, ERC721UniqueExtensions ) returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

        /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override (ERC20, ERC721) returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }
    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override (ERC20, ERC721) returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override (ERC20, ERC721) returns (uint256) {
        return _balances[account];
    }

}