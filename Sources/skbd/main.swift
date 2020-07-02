import Alicia
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

// swiftlint:disable let_var_whitespace
// XXX: re-enable once property wrappers do not trigger this

struct Arguments: ParsableArguments {
    @Option(name: .shortAndLong, help: ArgumentHelp("Path to the configuration file", valueName: "path"))
    var config: String = defaultConfigPath

    @Flag(name: .shortAndLong, help: "Reload the configuration file")
    var reload: Bool = false

    @Flag(name: .shortAndLong, help: "Display version information")
    var version: Bool = false
}

// swiftlint:enable let_var_whitespace

let arguments = Arguments.parseOrExit()

func printVersion() -> Int32 {
    print("skbd version \(majorVersion).\(minorVersion).\(patchVersion)")
    return EXIT_SUCCESS
}

func reloadConfig() -> Int32 {
    do {
        let pid = try PidFile.read()
        kill(pid, SIGUSR1)
        return EXIT_SUCCESS
    } catch PidFileError.failedToOpenFile {
        printError("error reading pid file - failed to open pid file")
    } catch PidFileError.failedToLockFile {
        printError("error reading pid file - failed to lock pid file")
    } catch PidFileError.failedToReadFile {
        printError("error reading pid file - failed to read pid file")
    } catch {
        printError("error reading pid file - \(error)")
    }

    return EXIT_FAILURE
}

func handleSigUsr1(_: Int32) {
    do {
        print("received sigusr1 - reloading configuration...")

        let config = try String(contentsOfFile: arguments.config)
        let shortcuts = try ConfigParser(config).parse()

        Alicia.reset()
        Alicia.register(shortcuts: shortcuts)
    } catch {
        printError("error parsing configuration file - \(error)")
    }
}

func handleSigInt(_: Int32) {
    print("received sigint - terminating...")
    NSApplication.shared.stop(nil)
}

func main(args _: [String]) -> Int32 {
    if arguments.version {
        return printVersion()
    }

    if arguments.reload {
        return reloadConfig()
    }

    do {
        try PidFile.create()
    } catch PidFileError.failedToOpenFile {
        printError("error creating pid file - failed to open pid file")
        return EXIT_FAILURE
    } catch PidFileError.failedToLockFile {
        printError("error creating pid file - failed to lock pid file")
        return EXIT_FAILURE
    } catch PidFileError.failedToWriteFile {
        printError("error creating pid file - failed to write pid file")
        return EXIT_FAILURE
    } catch {
        printError("error creating pid file - \(error)")
        return EXIT_FAILURE
    }

    do {
        let config = try String(contentsOfFile: arguments.config)
        let shortcuts = try ConfigParser(config).parse()

        Alicia.register(shortcuts: shortcuts)
        Alicia.start()
    } catch {
        printError("error parsing configuration file - \(error)")
        return EXIT_FAILURE
    }

    signal(SIGUSR1, handleSigUsr1)
    signal(SIGINT, handleSigInt)

    defer {
        Alicia.stop()
    }

    NSApplication.shared.run()

    return EXIT_SUCCESS
}

exit(main(args: CommandLine.arguments))
