import Carbon
import XCTest

import skbdlib

final class ParserTests: XCTestCase {
    func testParse() {
        let input = """
            # this if the first comment
            opt-space: open -a iTerm2.app

            # this is a comment
            # with multiple lines... + - ++
            cmd + shift - a : echo "Hello world"

            # this is another comment, followed by a multiline command
            ctrl + opt - return : echo "foo bar"; \
                rm -fr /
        """

        let keybinds = Parser(input).parse()

        XCTAssertEqual(keybinds[0].carbonKeyCode, UInt32(kVK_Space))
        XCTAssertEqual(keybinds[0].carbonModifiers, UInt32(optionKey))
        XCTAssertEqual(keybinds[0].command, "open -a iTerm2.app")

        XCTAssertEqual(keybinds[1].carbonKeyCode, UInt32(kVK_ANSI_A))
        XCTAssertEqual(keybinds[1].carbonModifiers, UInt32(cmdKey | shiftKey))
        XCTAssertEqual(keybinds[1].command, "echo \"Hello world\"")

        XCTAssertEqual(keybinds[2].carbonKeyCode, UInt32(kVK_Return))
        XCTAssertEqual(keybinds[2].carbonModifiers, UInt32(controlKey | optionKey))
        XCTAssertEqual(keybinds[2].command, "echo \"foo bar\";         rm -fr /")
    }
}
