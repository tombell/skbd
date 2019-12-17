public struct Token {
    public var type: TokenType
    public var text: String

    public var description: String {
        return "Token {type: \(type), text: \(text)}"
    }
}
