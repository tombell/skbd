import Foundation

extension StringProtocol {
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
}

public class Lexer {
    private var buffer: String

    private var at = Character("\0")
    private var pos: Int = 0
    private var readPos: Int = 0

    public init(_ buffer: String) {
        self.buffer = buffer

        advance()
    }

    public func getToken() -> Token? {
        skipWhitespace()

        var token: Token?

        switch at {
        case "\0":
            token = Token(type: .endOfStream, text: String(at))
        case "+":
            token = Token(type: .plus, text: String(at))
        case "-":
            token = Token(type: .dash, text: String(at))
        case "#":
            skipComment()
            token = getToken()
        default:
            token = Token(type: .unknown, text: String(at))
        }

        advance()

        return token
    }

    private func advance() {
        if readPos >= buffer.count {
            at = Character("\0")
        } else {
            at = buffer[readPos]
        }

        pos = readPos
        readPos += 1
    }

    private func skipWhitespace() {
        while at.isWhitespace {
            advance()
        }
    }

    private func skipComment() {
        while !at.isNewline, at != "\0" {
            advance()
        }
    }
}
