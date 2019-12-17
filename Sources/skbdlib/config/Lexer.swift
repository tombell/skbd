import Foundation



let modifierIdentifiers = [
    "shift",
    "ctrl", "control",
    "alt", "opt", "option",
    "cmd", "command",
    "hyper",
]

let keyIdentifiers = [
    "space", "tab", "return", "capslock",

    "pageup", "pagedown",
    "home", "end",
    "up", "right", "down", "left",

    "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10",
    "f11", "f12", "f13", "f14", "f15", "f16", "f17", "f18", "f19", "f20",

    "escape", "delete",
]

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
            token = Token(type: .comment, text: String("TODO"))
        case ":":
            skipWhitespace()
            let cmd = readCommand()
            token = Token(type: .command, text: cmd)
        default:
            if at.isLetter {
                let text = readIdentifier()
                let type = resolveIdentifierType(identifier: text)

                token = Token(type: type, text: text)
            } else {
                token = Token(type: .unknown, text: String(at))
            }
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

    private func readCommand() -> String {
        let start = readPos-1

        while !at.isNewline, at != "\0" {
            if at == "\\" {
                advance()
            }

            advance()
        }

        return buffer[start..<readPos-1]
    }

    private func readIdentifier() -> String {
        let start = readPos-1

        while at.isLetter || at == "_" {
            advance()
        }

        while at.isNumber {
            advance()
        }

        return buffer[start..<readPos-1]
    }

    private func resolveIdentifierType(identifier: String) -> TokenType {
        if identifier.count == 1 {
            return .key
        }

        if modifierIdentifiers.contains(identifier) {
            return .modifier
        }

        if keyIdentifiers.contains(identifier) {
            return .literal
        }

        return .identifier
    }
}
