//0x4a5eb6574Fe68c55362fc73b9EA76953d837985B

/**
 *Submitted for verification at BscScan.com on 2021-11-10
*/

// SPDX-License-Identifier: MIT

pragma solidity >=0.7.2;
pragma experimental ABIEncoderV2;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
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
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @title SafeMathInt
 * @dev Math operations with safety checks that revert on error
 * @dev SafeMath adapted for int256
 * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
 */
library SafeMathInt {
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when multiplying INT256_MIN with -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));

        int256 c = a * b;
        require((b == 0) || (c / b == a));
        return c;
    }

    function div(int256 a, int256 b) internal pure returns (int256) {
        // Prevent overflow when dividing INT256_MIN by -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == - 2**255 && b == -1) && (b > 0));

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256) {
        require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));

        return a - b;
    }

    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function toUint256Safe(int256 a) internal pure returns (uint256) {
        require(a >= 0);
        return uint256(a);
    }
}

/**
 * @title SafeMathUint
 * @dev Math operations with safety checks that revert on error
 */
library SafeMathUint {
    function toInt256Safe(uint256 a) internal pure returns (int256) {
        int256 b = int256(a);
        require(b >= 0);
        return b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {codehash := extcodehash(account)}
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success,) = recipient.call{value : amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
    * @dev Leaves the contract without owner. It will not be possible to call
    * `onlyOwner` functions anymore. Can only be called by the current owner.
    *
    * NOTE: Renouncing ownership will leave the contract without an owner,
    * thereby removing any functionality that is only available to the owner.
    */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock the token contract");
        require(block.timestamp > _lockTime, "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IFomo {
    function transferNotify(address user) external;

    function swap() external;

    function payReward(address user, uint256 amount) external;
}

interface IDividend {

    function swap() external;

    function swapAndDistributeDividends() external;
    
    function excludeFromDividends(address account) external;
    
    function setBalance(address payable account, uint256 newBalance) external;
    
    function process(uint256 gas) external returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) ;
    
}

interface IWrap {
    function withdraw() external;
}

contract PoordogeCoin is ERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    bool private inSwap = false;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;

    mapping(address => uint256) private _balances;
    mapping(address => uint256[2]) public accumulatePurchaseToday;

    address public immutable blackhole;
    address public router;
    IERC20 public usdt;
    address private _owner;
    address private _devReceiver;
    address public _fomoReceiver;
    address public _divReceiver;
    // address public  WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address public WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd; //testnet wbnb
    
    uint256 public _maxTotal = 700000 * 10 ** 8 * 10 ** 9;
    // uint256 public _maxTotal = 700000 * 10 ** 8 * 10 ** 9;
    uint256 public _total = 0;
    uint256 private _maxSell = 100 * 10 ** 8 * 10 ** 9;
    uint256 public minimumAmountToSwap = 10 * 10 ** 18;
    uint256 private buyTaxPrice = 100;
    
    string public _name = 'PoorDoge';
    string public _symbol = 'POORDOGE';
    uint8 private _decimals = 9;

    uint256 public gasForProcessing = 250000;
    uint256 public highestBuyTaxRate = 49;
    uint256 public highestSellTaxRate = 40;

    address public pdcWbnbPair;
    address public usdtWbnbPair;

    bool public swapAndLiquifyEnabled = false;
    bool public enableFee = false;

    bool public isAutoDividend = true;
    bool public isAutoSwapFomo = true;
    bool public isAutoSwapDividend = true;

    uint256 constant internal priceMagnitude = 2 ** 64;
    uint256 public basePrice;
    uint256 public basePriceTimeInterval = 1000;


    uint256 public lastBasePriceTimestamp;
    uint256 public startTimestamp;

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);

    event Logs(
        string logName,
        address logAddrss,
        uint256 longInt
    );

    event ProcessedDividendTracker(
        uint256 iterations,
        uint256 claims,
        uint256 lastProcessedIndex,
        bool indexed automatic,
        uint256 gas,
        address indexed processor
    );

    event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);

    event ExcludeFromFees(address indexed account, bool isExcluded);

    constructor (address _devRec, address _router, address _usdt)  ERC20("PoorDoge", "POORDOGE"){

        _owner = msg.sender;
        _devReceiver = _devRec;
        
        router = _router;
        usdt = IERC20(_usdt);

        _allowances[address(this)][router] = uint256(2**256 - 1);
        
        WBNB = IUniswapV2Router02(router).WETH();

        address _blackhole = 0x000000000000000000000000000000000000dEaD;
        blackhole = _blackhole;
        _isExcludedFromFee[_devReceiver] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_blackhole] = true;
        _isExcludedFromFee[_router] = true;

        startTimestamp = block.timestamp;

        _mint(_owner, _maxTotal);
        
        uint256 amountToBlackHole = _maxTotal.mul(39).div(100);
        _balances[_blackhole] = amountToBlackHole;
        _balances[_owner] = _balances[_owner].sub(amountToBlackHole);
        emit Transfer(_owner, _blackhole, amountToBlackHole);
        
    }
    
    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal override {
        require(account != address(0), "ERC20: mint to the zero address");
        require(_total.add(amount) <= _maxTotal, "reach maximum");

        _total = _total.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _total;
    }

    function balanceOf(address account) public view override returns (uint256) {

        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {

        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
    function switchOwner (address _newOwner) public {
        require(_msgSender() == owner(), "permission denied.");
        _owner = _newOwner;
    }
    
    function setBuyTaxPrice (uint256 _buyTaxRate) public {
        require(_msgSender() == owner(), "permission denied.");
        buyTaxPrice = _buyTaxRate;
    }
    
    function setBasePriceTimeInterval(uint256 _basePriceTimeInterval) public {
        require(_msgSender() == owner(), "permission denied.");
        basePriceTimeInterval = _basePriceTimeInterval;
    }
    
    function setHighestSellTaxRate (uint256 _highestSellTaxRate) public {
        require(_msgSender() == owner(), "permission denied.");
        highestSellTaxRate = _highestSellTaxRate;
    }
    
    function setHighestBuyTaxRate (uint256 _highestBuyTaxRate) public {
        require(_msgSender() == owner(), "permission denied.");
        highestBuyTaxRate = _highestBuyTaxRate;
    }
    
    function setWBNB(address _wbnb) public {
        require(_msgSender() == owner(), "permission denied.");
        WBNB = _wbnb;
    }
    
    function setMinimumAmountToSwap(uint256 _minimumAmountToSwap) public {
        require(_msgSender() == owner(), "permission denied.");
        minimumAmountToSwap = _minimumAmountToSwap;
    }
    
    function setMaxSell(uint256 __maxSell) public {
        require(_msgSender() == owner(), "permission denied.");
        _maxSell = __maxSell;
    }
    
    function setIsAutoDividend(bool _isAutoDividend) public {
        require(_msgSender() == owner(), "permission denied.");
        isAutoDividend = _isAutoDividend;
    }

    
    function setIsAutoSwapFomo(bool _isAutoSwapFomo) public {
        require(_msgSender() == owner(), "permission denied.");
        isAutoSwapFomo = _isAutoSwapFomo;
    }
    
        
    function setIsAutoSwapDividend(bool _isAutoSwapDividend) public {
        require(_msgSender() == owner(), "permission denied.");
        isAutoDividend = _isAutoSwapDividend;
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        require(_isExcludedFromFee[account] != excluded, "Poordoge Coin: Account is already the value of 'excluded'");
        _isExcludedFromFee[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function updateGasForProcessing(uint256 newValue) public onlyOwner {
        require(newValue >= 200000 && newValue <= 500000, "Poordoge Coin: gasForProcessing must be between 200,000 and 500,000");
        require(newValue != gasForProcessing, "Poordoge Coin: Cannot update gasForProcessing to same value");
        emit GasForProcessingUpdated(newValue, gasForProcessing);
        gasForProcessing = newValue;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function setFomo(address _fomo) public {
        require(_msgSender() == owner(), "permission denied.");
        _fomoReceiver = _fomo;
        _isExcludedFromFee[_fomo] = true;
        if (_divReceiver != address(0)) {
            IDividend(_divReceiver).excludeFromDividends(address(_fomoReceiver));
        }
    }

    function setDiv(address _div) public {
        require(_msgSender() == owner(), "permission denied.");
        _divReceiver = _div;
        _isExcludedFromFee[_div] = true;
        
        IDividend(_div).excludeFromDividends(_div);
        IDividend(_div).excludeFromDividends(address(this));
        IDividend(_div).excludeFromDividends(router);
        IDividend(_div).excludeFromDividends(address(_divReceiver));
        IDividend(_div).excludeFromDividends(address(blackhole));
        if (_fomoReceiver != address(0)) {
            IDividend(_div).excludeFromDividends(_fomoReceiver);
        }
        
        if (pdcWbnbPair != address(0)) {
            IDividend(_div).excludeFromDividends(pdcWbnbPair);
        }
        
        if (usdtWbnbPair != address(0)) {
            IDividend(_div).excludeFromDividends(usdtWbnbPair);
        }
    }
    
    function setRouter(address _router) public {
        require(_msgSender() == owner(), "permission denied.");
        router = _router;
        
        _isExcludedFromFee[_router] = true;
        if (_divReceiver != address(0)) {
            IDividend(_divReceiver).excludeFromDividends(_router);
        }
    }
    
    function setEnableFee(bool _enableFee) public {
        require(_msgSender() == owner(), "permission denied.");
        enableFee = _enableFee;
    }
    
    function setSwapAndLiquify (bool _swapAndLiquifyEnabled) public onlyOwner {
        swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
    }

    function _getBasePriceRate() public view returns (uint256) {
        uint256 basePriceNow = getBasePriceNow();
        if (basePriceNow == 0) return 0;
        uint256 lpPrice = getLpPriceNow();
        if (lpPrice == 0) return 0;
        return lpPrice.mul(1000).div(basePriceNow);
    }

    function _getAmountInUsdt(uint256 tokenAmount) public view returns (uint256) {

        if (tokenAmount <= 0) return 0;
        (uint256 _pdcReserve, uint256 _wbnbReserve) = _getPdcWbnbReserves();
        if (_wbnbReserve <= 0) return 0;
        if (_pdcReserve <= 0) return 0;
        uint256 wbnbIn = uint256(getAmountIn(tokenAmount, _wbnbReserve, _pdcReserve));
        
        (uint256 _wbnbReserve1, uint256 _usdtReserve) = _getWbnbUsdtReserves();
        if (_wbnbReserve1 <= 0) return 0;
        if (_usdtReserve <= 0) return 0;
        return uint256(getAmountIn(wbnbIn, _usdtReserve, _wbnbReserve1));
    }

    function _getAmountOutUsdt(uint256 tokenAmount) public view returns (uint256) {
        
        if (tokenAmount <= 0) return 0;
        (uint256 _pdcReserve, uint256 _wbnbReserve) = _getPdcWbnbReserves();
        if (_wbnbReserve <= 0 || _pdcReserve <= 0) return 0;
        uint256 wbnbOut = uint256(getAmountOut(tokenAmount, _pdcReserve, _wbnbReserve));
        
        (uint256 _wbnbReserve1, uint256 _usdtReserve) = _getWbnbUsdtReserves();
        if (_wbnbReserve1 <= 0 || _usdtReserve <= 0) return 0;
        return uint256(getAmountOut(wbnbOut, _wbnbReserve1, _usdtReserve));
        
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _approve(address owner, address spender, uint256 amount) internal override {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function checkLps() private {

        // Create a uniswap pair for this new token
        address _pdcWbnbPair = IUniswapV2Factory(IUniswapV2Router02(router).factory()).getPair(address(this), WBNB);
        if (pdcWbnbPair != _pdcWbnbPair) {
            pdcWbnbPair = _pdcWbnbPair;
            IDividend(_divReceiver).excludeFromDividends(address(_pdcWbnbPair));
        }
        
        address _usdtWbnbPair = IUniswapV2Factory(IUniswapV2Router02(router).factory()).getPair(address(usdt), WBNB);
        if (usdtWbnbPair != _usdtWbnbPair) {
             usdtWbnbPair = _usdtWbnbPair;
        }
       
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(from != to, "Sender and reciever must be different");
        require(amount > 0, "Transfer amount must be greater than zero");
        
        if (to == pdcWbnbPair && 
            enableFee && 
            from != _divReceiver &&
            from != _fomoReceiver &&
            from != _owner) {
            require(amount <= _maxSell, "sell amount reach maximum");
        }
        
        checkLps();

        if ((from == pdcWbnbPair || to == pdcWbnbPair) && enableFee) {
            _updateBasePrice();
        }
        
        if (from == pdcWbnbPair) {
            IFomo(_fomoReceiver).transferNotify(to);
        }
        
        if (from != pdcWbnbPair && !inSwap && enableFee) {
            inSwap = true;
            if(from != _fomoReceiver && isAutoSwapFomo) {
                _swapFomo();
            }
            if (from != _divReceiver && isAutoDividend) {
                _swapDividend();
            }
            inSwap = false;
        } 
        
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || !enableFee) {
            _transferWithoutFee(from, to, amount);
        } else {
            if (from == pdcWbnbPair) {
                _transferBuyStandard(from, to, amount);
            } else if (to == pdcWbnbPair) {
                _transferSellStandard(from, to, amount);
            } else {
                _transferStandard(from, to, amount);
            }
        }

        if (from == pdcWbnbPair) {
            _updateAccumulatePurchaseToday(amount, to);
        }
        
        try IDividend(_divReceiver).setBalance(payable(from), balanceOf(from)) {} catch {}

        try IDividend(_divReceiver).setBalance(payable(to), balanceOf(to)) {}  catch {}
        
        if(!inSwap && isAutoDividend) {
    	    uint256 gas = gasForProcessing;

        	try IDividend(_divReceiver).process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
        		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
        	} catch {}
        }

    }

    function _transferBuyStandard(address sender, address recipient, uint256 amount) private {

        uint256 amountInUsdtRaw = _getAmountInUsdt(amount);
        uint256 totalFee = _distributeBuyFees(amount, sender, recipient, amountInUsdtRaw);

        uint256 transferAmount = amount.sub(totalFee);
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(transferAmount);
        uint256 basePriceRate = _getBasePriceRate();
        if (basePriceRate < 900) {
            uint256 rewardRate = getBuyReward(basePriceRate);
            IFomo(_fomoReceiver).payReward(recipient, amountInUsdtRaw.mul(rewardRate).div(1000));
        }

        emit Transfer(sender, recipient, transferAmount);
    }
    
    function getBuyReward(uint256 basePriceRate) public pure returns(uint256) {
        if (basePriceRate > 900) return 0;
        uint256 diff = 900 - basePriceRate;
        uint256 toReturn = 80;
        toReturn = toReturn.add(diff.mul(3).div(10));
        if (toReturn > 200){
            return 200;
        } else {
            return toReturn;
        }
    }

    function _transferSellStandard(address from, address to, uint256 amount) private {
        uint256 totalFee = _distributeSellFees(from, amount);

        uint256 transferAmount = amount.sub(totalFee);
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(transferAmount);

        emit Transfer(from, to, transferAmount);
    }

    function _distributeSellFees(address from, uint256 amount) private returns (uint256 totalFee) {

        (uint256 devFee, uint256 fomoFee, uint256 divFee, uint256 liqFee) = _getSellFees(amount);
        _balances[_devReceiver] = _balances[_devReceiver].add(devFee);
        try IDividend(_divReceiver).setBalance(payable(_devReceiver), balanceOf(_devReceiver)) {} catch {}
        _balances[_fomoReceiver] = _balances[_fomoReceiver].add(fomoFee);
        _balances[_divReceiver] = _balances[_divReceiver].add(divFee);
        _balances[blackhole] = _balances[blackhole].add(liqFee);

        emit Transfer(from, _devReceiver, devFee);
        emit Transfer(from, _fomoReceiver, fomoFee);
        emit Transfer(from, _divReceiver, divFee);
        emit Transfer(from, blackhole, liqFee);

        return devFee.add(fomoFee).add(divFee).add(liqFee);
    }

    function _getSellFees(uint256 amount) private view returns (uint256 devFee, uint256 fomoFee, uint256 divFee, uint256 liqFee) {
        uint256 feeRate = _getSellTaxRate();
        uint256 amountOutUsdt = _getAmountOutUsdt(amount);
        uint256 amountOutUsdtAfterFee = amountOutUsdt.sub(amountOutUsdt.mul(feeRate).div(10000));
        uint256 amountInPd = _getAmountInPd(amountOutUsdtAfterFee);
        uint256 fee = amount.sub(amountInPd);  
        
        devFee = fee.mul(25).div(100);
        fomoFee = fee.mul(25).div(100);
        divFee = fee.mul(30).div(100);
        liqFee = fee.mul(20).div(100);
    }

    function _getSellTaxRate() public view returns (uint256) {
        uint256 rate = _getBasePriceRate();
        if (rate == 0) {
            return _convertToSellSlippage(100);
        }
        if (rate > 900 && rate <= 1200) {
            return _convertToSellSlippage(100);
        }
        uint256 diff;
        uint256 rateToReturn;
        if (rate > 1200) {
            diff = rate.sub(1200);
            rateToReturn = diff.mul(4).div(10).add(200);
            if (rateToReturn > highestSellTaxRate.mul(10)) {
                return _convertToSellSlippage(highestSellTaxRate.mul(10));
            } else {
                return _convertToSellSlippage(rateToReturn);
            }
        }

        diff = uint256(900).sub(rate);
        rateToReturn = diff.mul(8).div(10).add(200);
        if (rateToReturn > highestSellTaxRate.mul(10)) {
            return _convertToSellSlippage(highestSellTaxRate.mul(10));
        } else {
            return _convertToSellSlippage(rateToReturn);
        }

    }
    
    function _convertToSellSlippage(uint256 taxRate) private pure returns(uint256) {
        return uint256(10000).sub(uint256(10000000).div(uint256(1000).add(taxRate)));
    }

    function _getAmountInPd(uint256 amountOut) private view returns(uint256){
        
        if (amountOut <= 0) return 0;
                
        (uint256 _wbnbReserve1, uint256 _usdtReserve) = _getWbnbUsdtReserves();
        if (_wbnbReserve1 <= 0 || _usdtReserve <= 0) return 0;
        uint256 wbnbIn = uint256(getAmountIn(amountOut, _wbnbReserve1, _usdtReserve));
        
        (uint256 _pdcReserve, uint256 _wbnbReserve) = _getPdcWbnbReserves();
        if (_wbnbReserve <= 0 || _pdcReserve <= 0) return 0;
        return uint256(getAmountIn(wbnbIn, _pdcReserve, _wbnbReserve));
    }

    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        if (amountOut <= 0) return 0;
        if (reserveIn <= 0) return 0;
        if (reserveOut <= 0) return 0;
        uint numerator = reserveIn.mul(amountOut).mul(1000);
        uint denominator = reserveOut.sub(amountOut).mul(998);
        amountIn = (numerator / denominator).add(1);
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        if (amountIn <= 0) return 0;
        if (reserveIn <= 0) return 0;
        if (reserveOut <= 0) return 0;
        uint amountInWithFee = amountIn.mul(998);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }
    
    function _getPdcWbnbReserves() private view returns(uint256 _pdcReserve, uint256 _wbnbReserve) {
        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(pdcWbnbPair).getReserves();

        address token0 = IUniswapV2Pair(pdcWbnbPair).token0();
        if (token0 == address(this)) {
            _pdcReserve = uint256(reserve0);
            _wbnbReserve = uint256(reserve1);
        } else {
            _pdcReserve = uint256(reserve1);
            _wbnbReserve = uint256(reserve0);
        }
    }
    
    function _getWbnbUsdtReserves() private view returns(uint256 _wbnbReserve, uint256 _usdtReserve) {
        (uint112 reserve0, uint112 reserve1,) = IUniswapV2Pair(usdtWbnbPair).getReserves();

        address token0 = IUniswapV2Pair(pdcWbnbPair).token0();
        if (token0 == WBNB) {
            _wbnbReserve = uint256(reserve0);
            _usdtReserve = uint256(reserve1);
        } else {
            _wbnbReserve = uint256(reserve1);
            _usdtReserve = uint256(reserve0);
        }
    }

    function _transferStandard(address from, address to, uint256 amount) private {
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
    }

    function getAccumulatePurchaseToday(address account) public view returns (uint256[2] memory) {
        return accumulatePurchaseToday[account];
    }

    function _updateAccumulatePurchaseToday(uint256 amount, address to) private {
        uint256 usdtAmountInRaw = _getAmountInUsdt(amount);
        uint256 usdtAmountIn = usdtAmountInRaw.div(10 ** 18);
        if (usdtAmountInRaw.mod(10 ** 18) > 5 * 10 ** 17) {
            usdtAmountIn = usdtAmountIn.add(1);
        }
        if (accumulatePurchaseToday[to][1] != 0) {
            uint256 lastPurchaseDate = accumulatePurchaseToday[to][0];
            uint256 today = block.timestamp.div(24 * 3600);
            if (lastPurchaseDate == today) {
                accumulatePurchaseToday[to][1] = accumulatePurchaseToday[to][1].add(usdtAmountIn);
            } else {
                accumulatePurchaseToday[to][0] = today;
                accumulatePurchaseToday[to][1] = usdtAmountIn;
            }
        }
        else {
            uint256[2] memory r;
            r[0] = uint256(block.timestamp.div(24 * 3600));
            r[1] = uint256(usdtAmountIn);
            accumulatePurchaseToday[to] = r;
        }
    }

    function _updateBasePrice() private {
        (uint256 _pdcReserve, uint256 _wbnbReserve) = _getPdcWbnbReserves();
        if (_pdcReserve <= 0 || _wbnbReserve <= 0) return;
        uint256 currentPrice = getLpPriceNow();
        if(lastBasePriceTimestamp == 0) {
            lastBasePriceTimestamp = block.timestamp;
            basePrice = currentPrice;
            return;
        }
        uint256 lastTimeMin = lastBasePriceTimestamp.div(60);
        uint256 currentTimeMin = block.timestamp.div(60);
        if (currentTimeMin == lastTimeMin) {
            return;
        }
        uint256 startMin = startTimestamp.div(60);
        uint256 minSinceBegin = currentTimeMin.sub(startMin).add(1);
        uint256 timeInterval = basePriceTimeInterval;
        if (currentTimeMin > lastTimeMin) {
            uint256 minSinceLast = currentTimeMin.sub(lastTimeMin);
            if (minSinceBegin > timeInterval) {
                if (minSinceLast > timeInterval) {
                    basePrice = currentPrice;
                }  else {
                    basePrice = basePrice.mul(timeInterval.sub(minSinceLast)).div(timeInterval).add(currentPrice.mul(minSinceLast).div(timeInterval));
                }

            } else {
                if (minSinceBegin <= 60) {
                    basePrice = basePrice.mul(59).div(60).add(currentPrice.div(60));
                } else {
                    basePrice = basePrice.mul(minSinceBegin.sub(minSinceLast)).div(minSinceBegin).add(currentPrice.mul(minSinceLast).div(minSinceBegin));
                }
            }
        }

        lastBasePriceTimestamp = block.timestamp;

    }

    function getBasePriceNow() public view returns(uint256) {
        uint256 _currentLpPrice = getLpPriceNow();
        if (basePrice == 0) return _currentLpPrice;
        uint256 lastTimeMin = lastBasePriceTimestamp.div(60);
        uint256 currentTimeMin = block.timestamp.div(60);
        uint256 timeInterval = basePriceTimeInterval;
        if (currentTimeMin == lastTimeMin) {
            return basePrice;
        } else {
            uint256 startMin = uint256(startTimestamp).div(60);
            uint256 minSinceBegin = currentTimeMin.sub(startMin).add(1);
            uint256 minSinceLast = currentTimeMin.sub(lastTimeMin);
            if (minSinceBegin > timeInterval) {
                if(minSinceLast > timeInterval) {
                    return _currentLpPrice;
                } else {
                    return basePrice.mul(timeInterval.sub(minSinceLast)).div(timeInterval).add(_currentLpPrice.mul(minSinceLast).div(timeInterval));
                }

            } else if (minSinceBegin <= 60) {
                return basePrice.mul(59).div(60).add(_currentLpPrice.div(60));
            } else {
                return basePrice.mul(uint256(minSinceBegin).sub(minSinceLast)).div(minSinceBegin).add(_currentLpPrice.mul(minSinceLast).div(minSinceBegin));
            }
        }
    }
    
    function getLpPriceNow () public view returns(uint256) {
        (uint112 pwreserve0, uint112 pwreserve1,) = IUniswapV2Pair(pdcWbnbPair).getReserves();
        if (pwreserve0 == 0 || pwreserve1 == 0) {
            return 0;
        }

        address pwtoken0 = IUniswapV2Pair(pdcWbnbPair).token0();
        uint256 pdPriceInWbnb;
        if (pwtoken0 == address(this)) {
            pdPriceInWbnb = uint256(pwreserve1).mul(priceMagnitude).div(uint256(pwreserve0)).div(10 ** 9);
        } else {
            pdPriceInWbnb = uint256(pwreserve0).mul(priceMagnitude).div(uint256(pwreserve1)).div(10 ** 9);
        }
        
        (uint112 uwreserve0, uint112 uwreserve1,) = IUniswapV2Pair(usdtWbnbPair).getReserves();
        if (uwreserve0 == 0 || uwreserve1 == 0) {
            return 0;
        }
        address uwtoken0 = IUniswapV2Pair(pdcWbnbPair).token0();
        uint256 wbnbPriceInUsdt;
        if (uwtoken0 == WBNB) {
            wbnbPriceInUsdt = uint256(uwreserve1).mul(priceMagnitude).div(uint256(uwreserve0));
        } else {
            wbnbPriceInUsdt = uint256(uwreserve0).mul(priceMagnitude).div(uint256(uwreserve1));
        }
        return pdPriceInWbnb.mul(wbnbPriceInUsdt).div(priceMagnitude);
    }

    function _getBuyFees(uint256 amount, address to, uint256 amountInUsdt) private view returns (uint256 devFee, uint256 fomoFee, uint256 divFee, uint256 liqFee) {
        uint256 feeRate = _getBuyTaxRate(to, amountInUsdt);
        devFee = amount.mul(feeRate).mul(25).div(1000000);
        fomoFee = amount.mul(feeRate).mul(25).div(1000000);
        divFee = amount.mul(feeRate).mul(30).div(1000000);
        liqFee = amount.mul(feeRate).mul(20).div(1000000);
    }

    function _getBuyTaxRate(address to, uint256 amountInUsdt) public view returns (uint256) {

        uint256 amountIn = amountInUsdt.div(10 ** 18);
        if (amountInUsdt.mod(10 ** 18) > 5 * 10 ** 17) {
            amountIn = amountIn.add(1);
        }

        if (accumulatePurchaseToday[to][0] != 0) {
            uint256 today = block.timestamp.div(24 * 3600);
            uint256 lastBuyDate = accumulatePurchaseToday[to][0];
            if (today == lastBuyDate) {
                amountIn += accumulatePurchaseToday[to][1];
            }
        }
        uint256 toReturn;
        if (amountIn <= buyTaxPrice) {
            toReturn = 0;
        } else if (amountIn > buyTaxPrice && amountIn <= buyTaxPrice.mul(3)) {
            toReturn = _convertToBuySlippage(8);
        } else if (amountIn > buyTaxPrice.mul(3) && amountIn <= buyTaxPrice.mul(10)) {
            toReturn = _convertToBuySlippage(20);
        } else if (amountIn > buyTaxPrice.mul(10) && amountIn <= buyTaxPrice.mul(30)) {
            toReturn = _convertToBuySlippage(35);
        } else {
            toReturn = _convertToBuySlippage(highestBuyTaxRate);
        }
        
        return toReturn;
    }
    
    function _convertToBuySlippage(uint256 taxRate) private pure returns(uint256) {
        return uint256(10000).sub(uint256(1000000).div(uint256(100).add(taxRate)));
    }

    function _distributeBuyFees(uint256 amount, address sender, address to, uint256 amountInUsdt) private returns (uint256 totalFee) {
        (uint256 devFee, uint256 fomoFee, uint256 divFee, uint256 liqFee) = _getBuyFees(amount, to, amountInUsdt);

        if  (devFee != 0) {
            _balances[_devReceiver] = _balances[_devReceiver].add(devFee);
            try IDividend(_divReceiver).setBalance(payable(_devReceiver), balanceOf(_devReceiver)) {} catch {}
            emit Transfer(sender, _devReceiver, devFee);
        }
        if (fomoFee != 0) {
            _balances[_fomoReceiver] = _balances[_fomoReceiver].add(fomoFee);
             emit Transfer(sender, _fomoReceiver, fomoFee);
        }
        if (divFee != 0) {
             _balances[_divReceiver] = _balances[_divReceiver].add(divFee);
            emit Transfer(sender, _divReceiver, divFee);
        }
        if (liqFee != 0) {
            _balances[blackhole] = _balances[blackhole].add(liqFee);
            emit Transfer(sender, blackhole, liqFee);
        }

        return devFee.add(fomoFee).add(divFee).add(liqFee);
    }

    function _transferWithoutFee(address sender, address recipient, uint256 amount) private {
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }
    
    function swapFomo() public {
        IFomo(_fomoReceiver).swap();
    }

    function _swapFomo() private {
        uint256 fomoBal = balanceOf(_fomoReceiver);
        uint256 fomoBalInUsdt = _getAmountOutUsdt(fomoBal);
        if (fomoBalInUsdt >= minimumAmountToSwap) {
            IFomo(_fomoReceiver).swap();
        }
    }
    
    function swapDividend() public {
        IDividend(_divReceiver).swapAndDistributeDividends();
    }
    
    function _swapDividend() private {
        uint256 divBal = balanceOf(_divReceiver);
        uint256 divBalInUsdt = _getAmountOutUsdt(divBal);
        emit Logs('divBalInUsdt amount', address(0), divBalInUsdt);
        if (divBalInUsdt >= minimumAmountToSwap) {
            IDividend(_divReceiver).swapAndDistributeDividends();
        }
    }

}

