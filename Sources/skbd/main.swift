import AppKit
import ArgumentParser
import skbdlib

let majorVersion = 0
let minorVersion = 0
let patchVersion = 1

let defaultConfigPath = ("~/.config/skbd/skbdrc" as NSString).resolvingSymlinksInPath

struct StderrOutputStream: TextOutputStream {
    func write(_ string: String) { fputs(string, stderr) }
}

func printError(_ string: String) {
    var err = StderrOutputStream()
    print(string, to: &err)
}

struct Arguments: ParsableArguments {
    @Option(name: .shortAndLong,
            default: defaultConfigPath,
            help: ArgumentHelp("Path to the configuration file", valueName: "path"))
    var config: String

    @Flag(name: .shortAndLong, help: "Reload the configuration file")
    var reload: Bool

    @Flag(name: .shortAndLong, help: "Display version information")
    var version: Bool
}

let arguments = Arguments.parseOrExit()

func main(args _: [String]) -> Int32 {
    if arguments.version {
        print("skbd version \(majorVersion).\(minorVersion).\(patchVersion)")
        return EXIT_SUCCESS
    }

    do {
        if arguments.reload {
            let pid = try PidFile.read()
            kill(pid, SIGUSR1)
            return EXIT_SUCCESS
        }

        try PidFile.create()

        let config = try String(contentsOfFile: arguments.config)
        let keybinds = try ConfigParser(config).parse()

        KeybindController.register(keybinds: keybinds)
        KeybindController.start()

        signal(SIGUSR1) { _ in
            do {
                print("skbd: received SIGUSR1, reloading configuration...")

                let config = try String(contentsOfFile: arguments.config)
                let keybinds = try ConfigParser(config).parse()

                KeybindController.reset()
                KeybindController.register(keybinds: keybinds)
            } catch {
                printError("skbd: error occurred while reloading configuration, \(error)")
            }
        }

        signal(SIGINT) { _ in
            print("skbd: received SIGINT, terminating...")
            NSApplication.shared.stop(nil)
        }

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
