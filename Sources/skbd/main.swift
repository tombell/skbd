import AppKit
import skbdlib

let majorVersion = 0
let minorVersion = 0
let patchVersion = 1

var configPath: String = ConfigPath.resolve()

func main(args: [String]) -> Int32 {
    do {
        guard let arguments = try parseArguments(args) else {
            printUsage()
            return EXIT_SUCCESS
        }

        if arguments.version {
            print("skbd version \(majorVersion).\(minorVersion).\(patchVersion)")
            return EXIT_SUCCESS
        }

        if arguments.reload {
            let pid = try PidFile.read()
            kill(pid, SIGUSR1)
            return EXIT_SUCCESS
        }

        if !arguments.config.isEmpty {
            configPath = arguments.config
        }

        try PidFile.create()

        let config = try String(contentsOfFile: configPath)
        let keybinds = try ConfigParser(config).parse()

        KeybindController.register(keybinds: keybinds)
        KeybindController.start()

        signal(SIGUSR1, handlerSIGUSR1)
        signal(SIGINT, handlerSIGINT)

        defer {
            KeybindController.stop()
            PidFile.remove()
        }

        NSApplication.shared.run()

        return EXIT_SUCCESS
    } catch let ArgumentError.missingValue(arg) {
        printError("skbd: error parsing arguments, missing value for argument \(arg)")
    } catch PidFileError.missingEnvVarUser {
        printError("skbd: error creating pid file, USER environment variable is not set")
    } catch PidFileError.fileAlreadyExists {
        printError("skbd, error creating pid file, file already exists")
    } catch PidFileError.failedToCreateFile {
        printError("skbd: error creating pid file, could not create file")
    } catch {
        printError("skbd: error occurred, \(error)")
    }

    return EXIT_FAILURE
}

exit(main(args: CommandLine.arguments))
