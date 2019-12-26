import AppKit
import skbdlib

let major = 0
let minor = 0
let patch = 1

func main(args: [String]) -> Int32 {
    do {
        let arguments = try parseArguments(args)

        if (arguments.version) {
            print("skbd version \(major).\(minor).\(patch)")
            return EXIT_SUCCESS
        }

        if (arguments.reload) {
            // TODO: read pid-file and SIGUSR1
            return EXIT_SUCCESS
        }

        print("skbd")
        return EXIT_SUCCESS
    } catch ArgumentError.missingValue(let arg) {
        printError("skbd: missing value for argument \(arg)")
        return EXIT_FAILURE
    } catch {
        printError("skbd: unknown error occurred")
        return EXIT_FAILURE
    }
}

let code = main(args: CommandLine.arguments)
exit(code)
