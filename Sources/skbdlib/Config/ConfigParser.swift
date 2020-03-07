public enum ConfigParserError: Error {
    case expectedModifier
    case expectedPlusFollowedByModifier
    case expectedModifierFollowedByDash
    case expectedDashFollowedByKey
    case expectedColonFollowedByCommand
    case unexpectedNilToken
}

public class ConfigParser {
    private var lexer: Lexer

    private var currToken: Token?
    private var prevToken: Token?

    private var keybinds = [Keybind]()

    public init(_ buffer: String) {
        lexer = Lexer(buffer)
    }

    public func parse() throws -> [Keybind] {
        keybinds.removeAll()

        advance()

        while !isEndOfFile() {
            while check(type: .comment) {
                advance()
            }

            if isEndOfFile() {
                break
            }

            if check(type: .modifier) {
                keybinds.append(try parseKeybind())
            } else {
                throw ConfigParserError.expectedModifier
            }
        }

        return keybinds
    }

    private func parseKeybind() throws -> Keybind {
        var keybind = Keybind()

        let modifier = match(type: .modifier)

        if modifier {
            let modifiers = try parseModifier()
            keybind.modifierFlags = Modifier.flags(for: modifiers)
        }

        if modifier {
            if !match(type: .dash) {
                throw ConfigParserError.expectedModifierFollowedByDash
            }
        }

        if match(type: .key) {
            let key = try parseKey()
            keybind.keyCode = Key.code(for: key)
        } else {
            throw ConfigParserError.expectedDashFollowedByKey
        }

        if match(type: .command) {
            keybind.command = try parseCommand()
        } else {
            throw ConfigParserError.expectedColonFollowedByCommand
        }

        return keybind
    }

    private func parseModifier() throws -> [String] {
        guard let token = prevToken, let text = token.text else {
            throw ConfigParserError.unexpectedNilToken
        }

        var modifiers = [String]()

        if modifierIdentifiers.contains(text) {
            modifiers.append(text)
        }

        if match(type: .plus) {
            if match(type: .modifier) {
                modifiers.append(contentsOf: try parseModifier())
            } else {
                throw ConfigParserError.expectedPlusFollowedByModifier
            }
        }

        return modifiers
    }

    private func parseKey() throws -> String {
        guard let token = prevToken, let text = token.text else {
            throw ConfigParserError.unexpectedNilToken
        }

        return text
    }

    private func parseCommand() throws -> String {
        guard let token = prevToken, let text = token.text else {
            throw ConfigParserError.unexpectedNilToken
        }

        return text
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
            prevToken = currToken
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
