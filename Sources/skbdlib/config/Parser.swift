public class Parser {
    private var lexer: Lexer

    private var currToken: Token?

    public init(buffer: String) {
        lexer = Lexer(buffer)
    }

    // Check if the end of file has been reached.
    private func isEndOfFile() -> Bool {
        guard let token = currToken else {
            return false
        }

        return token.type == .endOfStream
    }

    // Advance to the next token.
    private func advance() {
        if !isEndOfFile() {
            currToken = lexer.getToken()
        }
    }

    // Check if the current token matches the given token type.
    private func check(type: TokenType) -> Bool {
        if isEndOfFile() {
            return false
        }

        guard let token = currToken else {
            return false
        }

        return token.type == type
    }

    // Check if the current token matches the given token type, and advance the token if it does.
    private func match(type: TokenType) -> Bool {
        if check(type: type) {
            advance()
            return true
        }

        return false
    }
}
