/*
 * Error logging tests
 * SPDX-License-Identifier: Apache-2.0
 */

pragma solidity >=0.6.10;

import {consolerr} from '../consolerr.sol';

contract consolerrTest {
    function testErrorBytes32A() public pure {
        bytes32 a = 0x00112233445566778899aabbccddeeffffeeddccbbaa99887766554433221100;
        consolerr.errorBytes32('consolerr test: ', a);
    }

    function testErrorBytes32B() public pure {
        bytes32 a = 0x00112233445566778899aabbccddeeffffeeddccbbaa99887766554433221100;
        bytes32 b = 0xffeeddccbbaa9988776655443322110000112233445566778899aabbccddeeff;
        consolerr.errorBytes32('consolerr test: ', a, b);
    }

    function testErrorBytes32C() public pure {
        bytes32 a = 0x00112233445566778899aabbccddeeffffeeddccbbaa99887766554433221100;
        bytes32 b = 0xffeeddccbbaa9988776655443322110000112233445566778899aabbccddeeff;
        bytes32 c = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        consolerr.errorBytes32('consolerr test: ', a, b, c);
    }

    function testErrorUintA() public pure {
        uint256 a = 123456789;
        consolerr.errorUint('consolerr test: ', a);
    }

    function testErrorUintB() public pure {
        uint256 a = 123456789;
        uint256 b = 0;
        consolerr.errorUint('consolerr test: ', a, b);
    }

    function testErrorUintC() public pure {
        uint256 a = 123456789;
        uint256 b = 0;
        uint256 c = 12345678909876543210123456789000998877665544332211584938485102340013249586777;
        consolerr.errorUint('consolerr test: ', a, b, c);
    }

    function testErrorAddressA() public pure {
        address a = 0x00112233445566778899AABbCCdDEeFfFFeEDdCc;
        consolerr.errorAddress('consolerr test: ', a);
    }

    function testErrorAddressB() public pure {
        address a = 0x00112233445566778899AABbCCdDEeFfFFeEDdCc;
        address b = 0xFFEEddcCBBAA9988776655443322110000112233;
        consolerr.errorAddress('consolerr test: ', a, b);
    }

    function testErrorAddressC() public pure {
        address a = 0x00112233445566778899AABbCCdDEeFfFFeEDdCc;
        address b = 0xFFEEddcCBBAA9988776655443322110000112233;
        address c = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
        consolerr.errorAddress('consolerr test: ', a, b, c);
    }

    function testErrorBytes() public pure {
        bytes memory a = new bytes(5);
        a[0] = 0x00;
        a[1] = 0x05;
        a[2] = 0x07;
        a[3] = 0x0a;
        a[4] = 0xfe;
        consolerr.errorBytes('consolerr test: ', a);
    }
}
