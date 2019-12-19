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
    private var buffer = ""
    private var current = Character("\0")
    private var readPos = 0

    public init(_ buffer: String) {
        self.buffer = buffer

        advance()
    }

    public func getToken() -> Token? {
        skipWhitespace()

        var token: Token?

        switch current {
        case "\0":
            token = Token(type: .endOfStream, text: String(current))
        case "+":
            token = Token(type: .plus, text: String(current))
        case "-":
            token = Token(type: .dash, text: String(current))
        case "#":
            skipComment()
            token = Token(type: .comment, text: "")
        case ":":
            skipWhitespace()
            let cmd = readCommand()
            token = Token(type: .command, text: cmd)
        default:
            if current.isLetter {
                let text = readIdentifier()
                let type = resolveIdentifierType(identifier: text)
                token = Token(type: type, text: text)
                return token
            } else {
                token = Token(type: .unknown, text: String(current))
            }
        }

        advance()

        return token
    }

    private func advance() {
        if readPos >= buffer.count {
            current = Character("\0")
        } else {
            current = buffer[readPos]
        }

        readPos += 1
    }

    private func skipWhitespace() {
        while current.isWhitespace {
            advance()
        }
    }

    private func skipComment() {
        while !current.isNewline, current != "\0" {
            advance()
        }
    }

    private func readCommand() -> String {
        let start = readPos - 1

        while !current.isNewline, current != "\0" {
            if current == "\\" {
                advance()
            }

            advance()
        }

        return buffer[start ..< readPos - 1]
    }

    private func readIdentifier() -> String {
        let start = readPos - 1

        while current.isLetter || current == "_" {
            advance()
        }

        while current.isNumber {
            advance()
        }

        return buffer[start ..< readPos - 1]
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
