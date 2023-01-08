// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/UD60x18.sol";
import { UD60x18_Test } from "../../UD60x18.t.sol";

contract Log2_Test is UD60x18_Test {
    function test_RevertWhen_LessThanOne() external {
        UD60x18 x = ud(1e18 - 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_LogInputTooSmall.selector, x));
        log2(x);
    }

    modifier GreaterThanOrEqualToOne() {
        _;
    }

    function powerOfTwo_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 0 }));
        sets.push(set({ x: 2e18, expected: 1e18 }));
        sets.push(set({ x: 4e18, expected: 2e18 }));
        sets.push(set({ x: 8e18, expected: 3e18 }));
        sets.push(set({ x: 16e18, expected: 4e18 }));
        sets.push(set({ x: 2 ** 195 * 10 ** 18, expected: 195e18 }));
        return sets;
    }

    function test_Log2_PowerOfTwo() external parameterizedTest(powerOfTwo_Sets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }

    function notPowerOfTwo_Sets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1.125e18, expected: 0.169925001442312346e18 }));
        sets.push(set({ x: E, expected: 1_442695040888963394 }));
        sets.push(set({ x: PI, expected: 1_651496129472318782 }));
        sets.push(set({ x: 1e24, expected: 19_931568569324174075 }));
        sets.push(set({ x: MAX_WHOLE_UD60x18, expected: 196_205294292027477728 }));
        sets.push(set({ x: MAX_UD60x18, expected: 196_205294292027477728 }));
        return sets;
    }

    function test_Log2_NotPowerOfTwo() external parameterizedTest(notPowerOfTwo_Sets()) GreaterThanOrEqualToOne {
        UD60x18 actual = log2(s.x);
        assertEq(actual, s.expected);
    }
}
