import Carbon
import XCTest

import class skbdLib.Key

final class KeyTests: XCTestCase {
    func testRelocatableKeys() {
        let cases = [
            "a": UInt32(kVK_ANSI_A),
            "b": UInt32(kVK_ANSI_B),
            "c": UInt32(kVK_ANSI_C),
            "d": UInt32(kVK_ANSI_D),

            "0": UInt32(kVK_ANSI_0),
            "1": UInt32(kVK_ANSI_1),
            "2": UInt32(kVK_ANSI_2),
            "3": UInt32(kVK_ANSI_3),

            ".": UInt32(kVK_ANSI_Period),
            "'": UInt32(kVK_ANSI_Quote),
            "]": UInt32(kVK_ANSI_RightBracket),
            ";": UInt32(kVK_ANSI_Semicolon),
        ]

        cases.forEach { key, val in XCTAssertEqual(Key.code(for: key), val) }
    }

    func testKeys() {
        let cases = [
            "f1": UInt32(kVK_F1),
            "f2": UInt32(kVK_F2),
            "f3": UInt32(kVK_F3),
            "f4": UInt32(kVK_F4),

            "space": UInt32(kVK_Space),
            "tab": UInt32(kVK_Tab),
            "return": UInt32(kVK_Return),
        ]

        cases.forEach { key, val in XCTAssertEqual(Key.code(for: key), val) }
    }
}
