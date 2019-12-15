import Carbon

public typealias Handler = () -> Void

public class Keybind {
    public let identifier = UUID()

    public var key: String
    public var modifiers: [String]

    public var handler: Handler?

    var carbonKeyCode: UInt32
    var carbonModifiers: UInt32

    public init(key: String, modifiers: [String], handler: Handler? = nil) {
        self.key = key
        self.modifiers = modifiers

        carbonKeyCode = Key.code(for: key)
        carbonModifiers = Modifier.flags(for: modifiers)

        self.handler = handler

        KeybindController.register(keybind: self)
    }

    deinit {
        KeybindController.unregister(keybind: self)
    }
}
