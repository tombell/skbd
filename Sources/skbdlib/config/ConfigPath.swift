import Foundation

public class ConfigPath {
    private static let primaryPaths: [String] = [
        "~/.config/skbd/skbdrc",
        "~/.skbdrc",
    ]

    public static func resolve() -> String {
        for configPath in primaryPaths {
            let resolvedPath = (configPath as NSString).resolvingSymlinksInPath

            if FileManager.default.fileExists(atPath: resolvedPath) {
                return resolvedPath
            }
        }

        return (primaryPaths.first! as NSString).resolvingSymlinksInPath
    }
}
