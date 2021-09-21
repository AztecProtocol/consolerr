/*
 * Error logging
 * Author: Zac Williamson, AZTEC
 * SPDX-License-Identifier: Apache-2.0
 */

pragma solidity >=0.6.10;

library consolerr {
    function errorBytes(string memory reasonString, bytes memory varA) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendBytes(varA, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function error(string memory reasonString, bytes32 varA) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        append0x(errorPtr);
        appendBytes32(varA, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function error(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        append0x(errorPtr);
        appendBytes32(varA, errorPtr);
        appendComma(errorPtr);
        append0x(errorPtr);
        appendBytes32(varB, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function error(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB,
        bytes32 varC
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        append0x(errorPtr);
        appendBytes32(varA, errorPtr);
        appendComma(errorPtr);
        append0x(errorPtr);
        appendBytes32(varB, errorPtr);
        appendComma(errorPtr);
        append0x(errorPtr);
        appendBytes32(varC, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorBytes32(string memory reasonString, bytes32 varA) internal pure {
        error(reasonString, varA);
    }

    function errorBytes32(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB
    ) internal pure {
        error(reasonString, varA, varB);
    }

    function errorBytes32(
        string memory reasonString,
        bytes32 varA,
        bytes32 varB,
        bytes32 varC
    ) internal pure {
        error(reasonString, varA, varB, varC);
    }

    function errorAddress(string memory reasonString, address varA) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendAddress(varA, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorAddress(
        string memory reasonString,
        address varA,
        address varB
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendAddress(varA, errorPtr);
        appendComma(errorPtr);
        appendAddress(varB, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorAddress(
        string memory reasonString,
        address varA,
        address varB,
        address varC
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendAddress(varA, errorPtr);
        appendComma(errorPtr);
        appendAddress(varB, errorPtr);
        appendComma(errorPtr);
        appendAddress(varC, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorUint(string memory reasonString, uint256 varA) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendUint(varA, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorUint(
        string memory reasonString,
        uint256 varA,
        uint256 varB
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendUint(varA, errorPtr);
        appendComma(errorPtr);
        appendUint(varB, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function errorUint(
        string memory reasonString,
        uint256 varA,
        uint256 varB,
        uint256 varC
    ) internal pure {
        (bytes32 revertPtr, bytes32 errorPtr) = initErrorPtr();
        appendString(reasonString, errorPtr);
        appendUint(varA, errorPtr);
        appendComma(errorPtr);
        appendUint(varB, errorPtr);
        appendComma(errorPtr);
        appendUint(varC, errorPtr);

        assembly {
            revert(revertPtr, add(mload(errorPtr), 0x44))
        }
    }

    function appendComma(bytes32 stringPtr) internal pure {
        assembly {
            let stringLen := mload(stringPtr)

            mstore(add(stringPtr, add(stringLen, 0x20)), ', ')
            mstore(stringPtr, add(stringLen, 2))
        }
    }

    function append0x(bytes32 stringPtr) internal pure {
        assembly {
            let stringLen := mload(stringPtr)
            mstore(add(stringPtr, add(stringLen, 0x20)), '0x')
            mstore(stringPtr, add(stringLen, 2))
        }
    }

    function appendString(string memory toAppend, bytes32 stringPtr) internal pure {
        assembly {
            let appendLen := mload(toAppend)
            let stringLen := mload(stringPtr)
            let appendPtr := add(stringPtr, add(0x20, stringLen))
            for {
                let i := 0
            } lt(i, appendLen) {
                i := add(i, 0x20)
            } {
                mstore(add(appendPtr, i), mload(add(toAppend, add(i, 0x20))))
            }

            // update string length
            mstore(stringPtr, add(stringLen, appendLen))
        }
    }

    function appendBytes(bytes memory toAppend, bytes32 stringPtr) internal pure {
        uint256 bytesLen;
        bytes32 inPtr;
        assembly {
            bytesLen := mload(toAppend)
            inPtr := add(toAppend, 0x20)
        }

        for (uint256 i = 0; i < bytesLen; i += 0x20) {
            bytes32 slice;
            assembly {
                slice := mload(inPtr)
                inPtr := add(inPtr, 0x20)
            }
            appendBytes32(slice, stringPtr);
        }

        uint256 offset = bytesLen % 0x20;
        if (offset > 0) {
            // update length
            assembly {
                let lengthReduction := sub(0x20, offset)
                let len := mload(stringPtr)
                mstore(stringPtr, sub(len, lengthReduction))
            }
        }
    }

    function appendUint(uint256 input, bytes32 result) internal pure {
        if (input < 10) {
            assembly {
                let len := mload(result)
                mstore(result, add(len, 0x01))
                mstore8(add(add(len, result), 0x20), add(input, 0x30))
            }
            return;
        }
        assembly {
            let mptr := mload(0x40)
            let table := add(mptr, 0x60)

            // Store lookup table that maps an integer from 0 to 99 into a 2-byte ASCII equivalent
            mstore(table, 0x0000000000000000000000000000000000000000000000000000000000003030)
            mstore(add(table, 0x20), 0x3031303230333034303530363037303830393130313131323133313431353136)
            mstore(add(table, 0x40), 0x3137313831393230323132323233323432353236323732383239333033313332)
            mstore(add(table, 0x60), 0x3333333433353336333733383339343034313432343334343435343634373438)
            mstore(add(table, 0x80), 0x3439353035313532353335343535353635373538353936303631363236333634)
            mstore(add(table, 0xa0), 0x3635363636373638363937303731373237333734373537363737373837393830)
            mstore(add(table, 0xc0), 0x3831383238333834383538363837383838393930393139323933393439353936)
            mstore(add(table, 0xe0), 0x3937393839390000000000000000000000000000000000000000000000000000)

            /**
             * Convert `input` into ASCII.
             *
             * Slice 2 base-10  digits off of the input, use to index the ASCII lookup table.
             *
             * We start from the least significant digits, write results into mem backwards,
             * this prevents us from overwriting memory despite the fact that each mload
             * only contains 2 byteso f useful data.
             **/
            {
                let v := input
                mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))
                mstore(0x10, mload(add(table, shl(1, mod(div(v, 100000000000000), 100)))))
                mstore(0x0e, mload(add(table, shl(1, mod(div(v, 10000000000000000), 100)))))
                mstore(0x0c, mload(add(table, shl(1, mod(div(v, 1000000000000000000), 100)))))
                mstore(0x0a, mload(add(table, shl(1, mod(div(v, 100000000000000000000), 100)))))
                mstore(0x08, mload(add(table, shl(1, mod(div(v, 10000000000000000000000), 100)))))
                mstore(0x06, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000), 100)))))
                mstore(0x04, mload(add(table, shl(1, mod(div(v, 100000000000000000000000000), 100)))))
                mstore(0x02, mload(add(table, shl(1, mod(div(v, 10000000000000000000000000000), 100)))))
                mstore(0x00, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000000000), 100)))))

                mstore(add(mptr, 0x40), mload(0x1e))

                v := div(v, 100000000000000000000000000000000)
                if v {
                    mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                    mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                    mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                    mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                    mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                    mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                    mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))
                    mstore(0x10, mload(add(table, shl(1, mod(div(v, 100000000000000), 100)))))
                    mstore(0x0e, mload(add(table, shl(1, mod(div(v, 10000000000000000), 100)))))
                    mstore(0x0c, mload(add(table, shl(1, mod(div(v, 1000000000000000000), 100)))))
                    mstore(0x0a, mload(add(table, shl(1, mod(div(v, 100000000000000000000), 100)))))
                    mstore(0x08, mload(add(table, shl(1, mod(div(v, 10000000000000000000000), 100)))))
                    mstore(0x06, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000), 100)))))
                    mstore(0x04, mload(add(table, shl(1, mod(div(v, 100000000000000000000000000), 100)))))
                    mstore(0x02, mload(add(table, shl(1, mod(div(v, 10000000000000000000000000000), 100)))))
                    mstore(0x00, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000000000), 100)))))

                    mstore(add(mptr, 0x20), mload(0x1e))
                }
                v := div(v, 100000000000000000000000000000000)
                if v {
                    mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                    mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                    mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                    mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                    mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                    mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                    mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))

                    mstore(mptr, mload(0x1e))
                }
            }

            // get the length of the input
            let len := 1
            {
                if gt(input, 999999999999999999999999999999999999999) {
                    len := add(len, 39)
                    input := div(input, 1000000000000000000000000000000000000000)
                }
                if gt(input, 99999999999999999999) {
                    len := add(len, 20)
                    input := div(input, 100000000000000000000)
                }
                if gt(input, 9999999999) {
                    len := add(len, 10)
                    input := div(input, 10000000000)
                }
                if gt(input, 99999) {
                    len := add(len, 5)
                    input := div(input, 100000)
                }
                if gt(input, 999) {
                    len := add(len, 3)
                    input := div(input, 1000)
                }
                if gt(input, 99) {
                    len := add(len, 2)
                    input := div(input, 100)
                }
                len := add(len, gt(input, 9))
            }

            let offset := sub(96, len)
            let oldlen := mload(result)
            mstore(result, add(len, oldlen))
            mstore(add(add(result, oldlen), 0x20), mload(add(mptr, offset)))
            mstore(add(add(result, oldlen), 0x40), mload(add(add(mptr, 0x20), offset)))
            mstore(add(add(result, oldlen), 0x60), mload(add(add(mptr, 0x40), offset)))
        }
    }

    function appendAddress(address input, bytes32 stringPtr) internal pure {
        bytes32 mut;
        assembly {
            mut := shl(96, input)
        }
        append0x(stringPtr);
        appendBytes32(mut, stringPtr);
        assembly {
            let len := mload(stringPtr)
            mstore(stringPtr, sub(len, 24))
        }
    }

    function appendBytes32(bytes32 input, bytes32 result) internal pure {
        if (uint256(input) == 0x00) {
            assembly {
                let len := mload(result)
                mstore(result, add(len, 0x40))
                mstore(add(add(result, len), 0x20), 0x3030303030303030303030303030303030303030303030303030303030303030)
                mstore(add(add(result, len), 0x40), 0x3030303030303030303030303030303030303030303030303030303030303030)
            }
        }
        assembly {
            let table := mload(0x40)

            // Store lookup table that maps an integer from 0 to 99 into a 2-byte ASCII equivalent
            // Store lookup table that maps an integer from 0 to ff into a 2-byte ASCII equivalent
            mstore(add(table, 0x1e), 0x3030303130323033303430353036303730383039306130623063306430653066)
            mstore(add(table, 0x3e), 0x3130313131323133313431353136313731383139316131623163316431653166)
            mstore(add(table, 0x5e), 0x3230323132323233323432353236323732383239326132623263326432653266)
            mstore(add(table, 0x7e), 0x3330333133323333333433353336333733383339336133623363336433653366)
            mstore(add(table, 0x9e), 0x3430343134323433343434353436343734383439346134623463346434653466)
            mstore(add(table, 0xbe), 0x3530353135323533353435353536353735383539356135623563356435653566)
            mstore(add(table, 0xde), 0x3630363136323633363436353636363736383639366136623663366436653666)
            mstore(add(table, 0xfe), 0x3730373137323733373437353736373737383739376137623763376437653766)
            mstore(add(table, 0x11e), 0x3830383138323833383438353836383738383839386138623863386438653866)
            mstore(add(table, 0x13e), 0x3930393139323933393439353936393739383939396139623963396439653966)
            mstore(add(table, 0x15e), 0x6130613161326133613461356136613761386139616161626163616461656166)
            mstore(add(table, 0x17e), 0x6230623162326233623462356236623762386239626162626263626462656266)
            mstore(add(table, 0x19e), 0x6330633163326333633463356336633763386339636163626363636463656366)
            mstore(add(table, 0x1be), 0x6430643164326433643464356436643764386439646164626463646464656466)
            mstore(add(table, 0x1de), 0x6530653165326533653465356536653765386539656165626563656465656566)
            mstore(add(table, 0x1fe), 0x6630663166326633663466356636663766386639666166626663666466656666)
            /**
             * Convert `input` into ASCII.
             *
             * Slice 2 base-10  digits off of the input, use to index the ASCII lookup table.
             *
             * We start from the least significant digits, write results into mem backwards,
             * this prevents us from overwriting memory despite the fact that each mload
             * only contains 2 byteso f useful data.
             **/

            let base := input
            function slice(v, tableptr) {
                mstore(0x1e, mload(add(tableptr, shl(1, and(v, 0xff)))))
                mstore(0x1c, mload(add(tableptr, shl(1, and(shr(8, v), 0xff)))))
                mstore(0x1a, mload(add(tableptr, shl(1, and(shr(16, v), 0xff)))))
                mstore(0x18, mload(add(tableptr, shl(1, and(shr(24, v), 0xff)))))
                mstore(0x16, mload(add(tableptr, shl(1, and(shr(32, v), 0xff)))))
                mstore(0x14, mload(add(tableptr, shl(1, and(shr(40, v), 0xff)))))
                mstore(0x12, mload(add(tableptr, shl(1, and(shr(48, v), 0xff)))))
                mstore(0x10, mload(add(tableptr, shl(1, and(shr(56, v), 0xff)))))
                mstore(0x0e, mload(add(tableptr, shl(1, and(shr(64, v), 0xff)))))
                mstore(0x0c, mload(add(tableptr, shl(1, and(shr(72, v), 0xff)))))
                mstore(0x0a, mload(add(tableptr, shl(1, and(shr(80, v), 0xff)))))
                mstore(0x08, mload(add(tableptr, shl(1, and(shr(88, v), 0xff)))))
                mstore(0x06, mload(add(tableptr, shl(1, and(shr(96, v), 0xff)))))
                mstore(0x04, mload(add(tableptr, shl(1, and(shr(104, v), 0xff)))))
                mstore(0x02, mload(add(tableptr, shl(1, and(shr(112, v), 0xff)))))
                mstore(0x00, mload(add(tableptr, shl(1, and(shr(120, v), 0xff)))))
            }

            let len := mload(result)
            mstore(result, add(len, 0x40))
            slice(base, table)
            mstore(add(add(len, result), 0x40), mload(0x1e))
            base := shr(128, base)
            slice(base, table)
            mstore(add(add(len, result), 0x20), mload(0x1e))
        }
    }

    function initErrorPtr() internal pure returns (bytes32, bytes32) {
        bytes32 mPtr;
        bytes32 errorPtr;
        assembly {
            mPtr := mload(0x40)
            mstore(0x40, add(mPtr, 0x1000)) // let's reserve a LOT of memory for our error string.
            mstore(mPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
            mstore(add(mPtr, 0x04), 0x20)
            mstore(add(mPtr, 0x24), 0)
            errorPtr := add(mPtr, 0x24)
        }

        return (mPtr, errorPtr);
    }
}
