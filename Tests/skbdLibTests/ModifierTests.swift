import Carbon
import XCTest

import class skbdLib.Modifier

final class ModifierTests: XCTestCase {
    func testShiftModifierFlags() {
        XCTAssertEqual(Modifier.flags(for: ["shift"]), UInt32(shiftKey))
    }

    func testControlModifierFlags() {
        XCTAssertEqual(Modifier.flags(for: ["ctrl"]), UInt32(controlKey))
        XCTAssertEqual(Modifier.flags(for: ["control"]), UInt32(controlKey))
    }

    func testOptionModifierFlags() {
        XCTAssertEqual(Modifier.flags(for: ["alt"]), UInt32(optionKey))
        XCTAssertEqual(Modifier.flags(for: ["opt"]), UInt32(optionKey))
        XCTAssertEqual(Modifier.flags(for: ["option"]), UInt32(optionKey))
    }

    func testCommandModifierFlags() {
        XCTAssertEqual(Modifier.flags(for: ["cmd"]), UInt32(cmdKey))
        XCTAssertEqual(Modifier.flags(for: ["command"]), UInt32(cmdKey))
    }

    func testMultipleModifierFlags() {
        XCTAssertEqual(
            Modifier.flags(for: ["shift", "ctrl", "alt", "cmd"]),
            UInt32(shiftKey | controlKey | optionKey | cmdKey)
        )
    }
}
