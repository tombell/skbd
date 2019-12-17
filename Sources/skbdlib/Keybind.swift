import Carbon

public typealias Handler = () -> Void

public class Keybind {
    public let identifier = UUID()

    public var carbonKeyCode: UInt32
    public var carbonModifiers: UInt32
    public var handler: Handler?

    public init(key: String, modifiers: [String], handler: Handler? = nil) {
        carbonKeyCode = Key.code(for: key)
        carbonModifiers = Modifier.flags(for: modifiers)

        self.handler = handler

        KeybindController.register(keybind: self)
    }

    public init(carbonKeyCode: UInt32, carbonModifiers: UInt32, handler: Handler? = nil) {
        self.carbonKeyCode = carbonKeyCode
        self.carbonModifiers = carbonModifiers

        self.handler = handler

        KeybindController.register(keybind: self)
    }

    deinit {
        KeybindController.unregister(keybind: self)
    }
}
