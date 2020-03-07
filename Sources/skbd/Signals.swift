import AppKit
import skbdlib

func handlerSIGINT(_: Int32) {
    print("skbd: received SIGINT, terminating...")
    NSApplication.shared.stop(nil)
}

func handlerSIGUSR1(_: Int32) {
    do {
        print("skbd: received SIGUSR1, reloading configuration...")

        let config = try String(contentsOfFile: options!.config)
        let keybinds = try ConfigParser(config).parse()

        KeybindController.reset()
        KeybindController.register(keybinds: keybinds)
    } catch {
        printError("skbd: error occurred while reloading configuration, \(error)")
    }
}
