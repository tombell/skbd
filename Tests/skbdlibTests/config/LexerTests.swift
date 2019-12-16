import XCTest

import skbdlib

final class LexerTests: XCTestCase {
    func testGetToken() {
        let input = """
            +-  -+ -
               +++ ---    -+-+
            # this is a comment
            # with multiple lines... + - ++
        """

        let expected: [TokenType] = [
            .plus, .dash, .dash, .plus, .dash,
            .plus, .plus, .plus, .dash, .dash, .dash, .dash, .plus, .dash, .plus,
            .endOfStream,
        ]

        let lexer = Lexer(buffer: input)

        for type in expected {
            guard let token = lexer.getToken() else {
                return XCTFail()
            }

            XCTAssertEqual(token.type, type)
        }
    }
}
