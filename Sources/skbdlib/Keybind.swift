import Carbon

public typealias Handler = () -> Void

public struct Keybind {
    public let identifier = UUID()

    public var carbonKeyCode: UInt32?
    public var carbonModifiers: UInt32?

    public var command: String?

    public var handler: Handler?
}
