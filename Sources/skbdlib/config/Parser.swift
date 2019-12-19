public class Parser {
    private var lexer: Lexer

    private var currToken: Token?
    private var prevToken: Token?

    private var keybinds = [Keybind]()

    public init(_ buffer: String) {
        lexer = Lexer(buffer)
    }

    public func parse() -> [Keybind] {
        keybinds.removeAll()

        advance()

        while !isEndOfFile() {
            while check(type: .comment) {
                advance()
            }

            if check(type: .modifier) {
                keybinds.append(parseKeybind())
            } else {
                fatalError("expected modifier")
            }
        }

        return keybinds
    }

    private func parseKeybind() -> Keybind {
        var keybind = Keybind()

        let modifier = match(type: .modifier)

        if modifier {
            let modifiers = parseModifier()
            keybind.modifierFlags = Modifier.flags(for: modifiers)
        }

        if modifier {
            if !match(type: .dash) {
                fatalError("expected dash after modifiers")
            }
        }

        if match(type: .key) {
            let key = parseKey()
            keybind.keyCode = Key.code(for: key)
        } else {
            fatalError("expected key after dash")
        }

        if match(type: .command) {
            keybind.command = parseCommand()
        } else {
            fatalError("expected colon followed by command")
        }

        return keybind
    }

    private func parseModifier() -> [String] {
        guard let token = prevToken, let text = token.text else {
            fatalError("prevToken or text is nil")
        }

        var modifiers = [String]()

        if modifierIdentifiers.contains(text) {
            modifiers.append(text)
        }

        if match(type: .plus) {
            if match(type: .modifier) {
                modifiers.append(contentsOf: parseModifier())
            } else {
                fatalError("expected modifier")
            }
        }

        return modifiers
    }

    private func parseKey() -> String {
        guard let token = prevToken, let text = token.text else {
            fatalError("prevToken or text is nil")
        }

        return text
    }

    private func parseCommand() -> String {
        guard let token = prevToken, let text = token.text else {
            fatalError("prevToken or text is nil")
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
