import Carbon

public typealias Handler = () -> Void

public struct Keybind {
    public let identifier = UUID()

    public var keyCode: UInt32?
    public var modifierFlags: UInt32?

    public var command: String?

    // TODO: handler should probably be a built in func that execs self.command
    public var handler: Handler?
}
