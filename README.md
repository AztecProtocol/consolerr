# consolerr, Solidity error logging with runtime variables

Debugging Solidity code getting you down? Having trouble printing data when your transaction throws? consolerr can help!

### Usage:

```
import { consolerr } from 'error.sol';

contract Token {
    function sneaky() external {
        address vb = address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B);

        if (msg.sender != vb) {
            consolerr.errorAddress("Addresses do not match! ", msg.sender, vb);
        }
        mint(vb, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
    }
}
```

Results:

```
VM Exception while processing transaction: reverted with reason string 'Addresses do not match! 0xe6e340d132b5f46d1e472debcd681b2abc16e57e, 0xab5801a7d398351b8be11c439e05c5b3259aec9b'
```

```
import { consolerr } from 'error.sol';

contract Token {
    function withdraw() external
        if (balances[msg.sender] < 10000000000) {
            consolerr.errorUint("Insufficient balance: ", balances[msg.sender]);
        }
    }
}
```

Results:

```
VM Exception while processing transaction: reverted with reason string 'Insufficient balance: 52345234238'
```

---

## Supported types

consolerr can log the following types:

- `uint256` up to 3 per log
- `bytes32` up to 3 per log
- `address` up to 3 per log
- `bytes`

---

## consolerr Interface

```
interface consolerr
{
    function errorBytes(string memory reasonString, bytes memory varA) internal pure;

    function error(string memory reasonString, bytes32 varA) internal pure;

    function error(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB
    ) internal pure;

    function error(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB,
        bytes32 varC
    ) internal pure;

    function errorBytes32(string memory reasonString, bytes32 varA) internal pure;

    function errorBytes32(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB
    ) internal pure;

    function errorBytes32(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB,
        bytes32 varC
    ) internal pure;

    function errorAddress(string memory reasonString, address varA) internal pure;

    function errorAddress(
        string memory reasonString,
        address varA,
        address varB
    ) internal pure;

    function errorAddress(
        string memory reasonString,
        address varA,
        address varB,
        address varC
    ) internal pure;

    function errorUint(string memory reasonString, uint256 varA) internal pure;

    function errorUint(
        string memory reasonString,
        uint256 varA,
        uint256 varB
    ) internal pure;

    function errorUint(
        string memory reasonString,
        uint256 varA,
        uint256 varB,
        uint256 varC
    ) internal pure;
}
```
