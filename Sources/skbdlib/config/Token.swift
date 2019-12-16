public class Token {
    public var type: TokenType
    public var text: String

    public init(type: TokenType, text: String) {
        self.type = type
        self.text = text
    }
}
