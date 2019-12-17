import XCTest

import skbdlib

final class LexerTests: XCTestCase {
    func testGetToken() {
        let input = """
            +-  -+ -
            # this if the first comment
               +++ ---    -+-+
            # this is a comment
            # with multiple lines... + - ++
        """

        let expected: [TokenType] = [
            .plus, .dash, .dash, .plus, .dash,
            .comment,
            .plus, .plus, .plus, .dash, .dash, .dash, .dash, .plus, .dash, .plus,
            .comment,
            .comment,
            .endOfStream,
        ]

        let lexer = Lexer(input)

        for type in expected {
            guard let token = lexer.getToken() else {
                return XCTFail()
            }

            XCTAssertEqual(token.type, type)
        }
    }
}
