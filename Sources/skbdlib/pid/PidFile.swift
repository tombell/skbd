import Foundation

public enum PidFileError: Error {
    case missingEnvVarUser
    case fileAlreadyExists
    case failedToCreateFile
    case failedToReadFile
    case invalidPid
}

public class PidFile {
    private static func path() throws -> URL {
        guard let user = ProcessInfo.processInfo.environment["USER"] else {
            throw PidFileError.missingEnvVarUser
        }

        let filename = "skbd_\(user).pid"
        return FileManager.default.temporaryDirectory.appendingPathComponent(filename, isDirectory: false)
    }

    public static func create() throws {
        let url = try path()

        if FileManager.default.fileExists(atPath: url.path) {
            throw PidFileError.fileAlreadyExists
        }

        if !FileManager.default.createFile(atPath: url.path, contents: Data("\(getpid())".utf8), attributes: nil) {
            throw PidFileError.failedToCreateFile
        }
    }

    public static func read() throws -> pid_t {
        let url = try path()

        guard let data = try? String(contentsOf: url) else {
            throw PidFileError.failedToReadFile
        }

        guard let pid = Int32(data) else {
            throw PidFileError.invalidPid
        }

        return pid
    }

    public static func remove() {
        guard let url = try? self.path() else {
            return
        }

        try? FileManager.default.removeItem(at: url)
    }
}
