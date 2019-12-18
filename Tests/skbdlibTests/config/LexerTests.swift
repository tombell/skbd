import XCTest

import skbdlib

final class LexerTests: XCTestCase {
    func testGetToken() {
        let input = """
            # this if the first comment
            opt - space : open -a iTerm2.app

            # this is a comment
            # with multiple lines... + - ++
            cmd + shift - a : echo "Hello world"

            # this is another comment, followed by a multiline command
            ctrl + opt - return : echo "foo bar"; \
                rm -fr /
        """

        let expected: [TokenType] = [
            .comment,
            .modifier, .dash, .literal, .command,
            .comment,
            .comment,
            .modifier, .plus, .modifier, .dash, .key, .command,
            .comment,
            .modifier, .plus, .modifier, .dash, .literal, .command,
            .endOfStream,
        ]

        let lexer = Lexer(input)

        for type in expected {
            guard let token = lexer.getToken() else {
                return XCTFail("getToken() returned nil token")
            }

            XCTAssertEqual(token.type, type)
        }
    }
}
