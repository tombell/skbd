import Carbon

class Keybind {
    typealias Handler = () -> Void

    let identifier = UUID()

    var carbonKeyCode: UInt32
    var carbonModifiers: UInt32
    var handler: Handler?

    init(carbonKeyCode: UInt32, carbonModifiers: UInt32, handler: Handler? = nil) {
        self.carbonKeyCode = carbonKeyCode
        self.carbonModifiers = carbonModifiers
        self.handler = handler

//        KeybindController.register(keybind: self)
    }

    deinit {
//        KeybindController.unregister(keybind: self)
    }
}
