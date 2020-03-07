import AppKit
import ArgumentParser
import skbdlib

let majorVersion = 0
let minorVersion = 0
let patchVersion = 1

struct SkbdOptions: ParsableArguments {
    @Option(name: .shortAndLong,
            default: ConfigPath.resolve(),
            help: ArgumentHelp("Path to the configuration", valueName: "path"))
    var config: String

    @Flag(name: .shortAndLong, help: "Reload the configuration file")
    var reload: Bool

    @Flag(name: .shortAndLong, help: "Display version information")
    var version: Bool
}

var options: SkbdOptions?

func main(args _: [String]) -> Int32 {
    do {
        options = SkbdOptions.parseOrExit()

        if options!.version {
            print("skbd version \(majorVersion).\(minorVersion).\(patchVersion)")
            return EXIT_SUCCESS
        }

        if options!.reload {
            let pid = try PidFile.read()
            kill(pid, SIGUSR1)
            return EXIT_SUCCESS
        }

        try PidFile.create()

        let config = try String(contentsOfFile: options!.config)
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
