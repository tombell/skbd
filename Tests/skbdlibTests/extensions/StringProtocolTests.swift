import XCTest

import skbdlib

final class StringProtocolTests: XCTestCase {
    func testIndexing() {
        let str = "Hello world 😍"

        XCTAssertEqual(str[1], "e")
        XCTAssertEqual(str[5], " ")
        XCTAssertEqual(str[8], "r")
        XCTAssertEqual(str[12], "😍")
    }

    func testRangeIndexing() {
        let str = "Hello world 🤦🏻‍♂️"

        XCTAssertEqual(str[0 ..< 5], "Hello")
        XCTAssertEqual(str[6 ..< 11], "world")
        XCTAssertEqual(str[12 ..< 13], "🤦🏻‍♂️")
    }
}
