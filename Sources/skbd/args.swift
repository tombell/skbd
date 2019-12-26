import Foundation

typealias Arguments = (version: Bool, config: String, reload: Bool)

enum ArgumentError: Error {
    case missingValue(for: String)
}

func parseArguments(_ args: [String]) throws -> Arguments {
    var config: String = ""
    var reload: Bool = false
    var version: Bool = false

    var arguments = args.makeIterator()

    while let arg = arguments.next() {
        switch arg {
        case "--config", "-c":
            guard let cfg = arguments.next() else {
                throw ArgumentError.missingValue(for: arg)
            }

            config = cfg
        case "--reload", "-r":
            reload = true
        case "--version", "-v":
            version = true
        default:
            continue
        }
    }

    return Arguments(version, config, reload)
}
