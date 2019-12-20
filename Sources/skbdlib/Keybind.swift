import Foundation

func resolveShell() -> String {
    if let shell = ProcessInfo.processInfo.environment["SHELL"] {
        if !shell.isEmpty {
            return shell
        }
    }

    return "/bin/bash"
}

public struct Keybind {
    public let identifier = UUID()

    public var keyCode: UInt32?
    public var modifierFlags: UInt32?

    public var command: String?

    public func handler() {
        guard let command = command else {
            return
        }

        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: resolveShell())
        proc.arguments = ["-c", command]
        try? proc.run()
    }
}
