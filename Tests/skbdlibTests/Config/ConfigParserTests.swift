import Carbon
import XCTest

import skbdlib

final class ConfigParserTests: XCTestCase {
    func testParseOnlyComment() {
        let input = "# this is just a comment"

        XCTAssertNoThrow(try ConfigParser(input).parse())
    }

    func testParseMissingModifier() {
        let input = "space: open -a iTerm2.app"

        XCTAssertThrowsError(try ConfigParser(input).parse()) { err in
            XCTAssertTrue(err is ConfigParserError)
            XCTAssertEqual(err as? ConfigParserError, .expectedModifier)
        }
    }

    func testParseMissingModiferFollowingPlus() {
        let input = "opt + : open -a iTerm2.app"

        XCTAssertThrowsError(try ConfigParser(input).parse()) { err in
            XCTAssertTrue(err is ConfigParserError)
            XCTAssertEqual(err as? ConfigParserError, .expectedPlusFollowedByModifier)
        }
    }

    func testParseMissingDashFollowingModifier() {
        let input = "opt + ctrl : open -a iTerm2.app"

        XCTAssertThrowsError(try ConfigParser(input).parse()) { err in
            XCTAssertTrue(err is ConfigParserError)
            XCTAssertEqual(err as? ConfigParserError, .expectedModifierFollowedByDash)
        }
    }

    func testParseMissingKeyFollowingDash() {
        let input = "opt+ctrl-: open -a iTerm2.app"

        XCTAssertThrowsError(try ConfigParser(input).parse()) { err in
            XCTAssertTrue(err is ConfigParserError)
            XCTAssertEqual(err as? ConfigParserError, .expectedDashFollowedByKey)
        }
    }

    func testParseMissingCommand() {
        let input = "opt+ctrl-a+opt"

        XCTAssertThrowsError(try ConfigParser(input).parse()) { err in
            XCTAssertTrue(err is ConfigParserError)
            XCTAssertEqual(err as? ConfigParserError, .expectedColonFollowedByCommand)
        }
    }

    func testParse() {
        let input = """
            # this if the first comment, without whitespace
            opt-space:open -a iTerm2.app

            # this is a comment
            # with multiple lines... + - ++
            cmd + shift - a : echo "Hello world"

            # this is another comment, followed by a multiline command
            ctrl + opt - return : echo "foo bar"; \
                rm -fr /
        """

        do {
            let shortcuts = try ConfigParser(input).parse()

            XCTAssertEqual(shortcuts[0].keyCode, UInt32(kVK_Space))
            XCTAssertEqual(shortcuts[0].modifierFlags, UInt32(optionKey))

            XCTAssertEqual(shortcuts[1].keyCode, UInt32(kVK_ANSI_A))
            XCTAssertEqual(shortcuts[1].modifierFlags, UInt32(cmdKey | shiftKey))

            XCTAssertEqual(shortcuts[2].keyCode, UInt32(kVK_Return))
            XCTAssertEqual(shortcuts[2].modifierFlags, UInt32(controlKey | optionKey))
        } catch {
            XCTFail("expected not to throw an error")
        }
    }
}
