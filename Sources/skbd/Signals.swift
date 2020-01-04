import AppKit
import skbdlib

func handlerSIGINT(_: Int32) {
    NSApplication.shared.stop(nil)
}

func handlerSIGUSR1(_: Int32) {
    do {
        let config = try String(contentsOfFile: configPath)
        let keybinds = try ConfigParser(config).parse()

        KeybindController.reset()
        KeybindController.register(keybinds: keybinds)
    } catch {
        printError("error occurred while reloading configuration: \(error)")
    }
}
