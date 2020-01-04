import AppKit
import skbdlib

let majorVersion = 0
let minorVersion = 0
let patchVersion = 1

func main(args: [String]) -> Int32 {
    do {
        guard let arguments = try parseArguments(args) else {
            // TODO: print help usage
            print("skbd usage")
            return EXIT_SUCCESS
        }

        if arguments.version {
            print("skbd version \(majorVersion).\(minorVersion).\(patchVersion)")
            return EXIT_SUCCESS
        }

        if arguments.reload {
            // TODO: read pid-file and SIGUSR1
            return EXIT_SUCCESS
        }

        let config = try String(contentsOfFile: arguments.config)
        let keybinds = try ConfigParser(config).parse()

        KeybindController.register(keybinds: keybinds)
        KeybindController.start()

        NSApplication.shared.run()

        return EXIT_SUCCESS
    } catch let ArgumentError.missingValue(arg) {
        printError("error missing value for argument \(arg)")
        return EXIT_FAILURE
    } catch {
        printError("error occurred: \(error)")
        return EXIT_FAILURE
    }
}

exit(main(args: CommandLine.arguments))
