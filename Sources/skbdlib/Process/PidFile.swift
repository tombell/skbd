import Darwin
import Foundation

public enum PidFileError: Error {
    case missingEnvVarUser
    case failedToOpenFile
    case failedToReadFile
    case failedToWriteFile
    case failedToLockFile
}

public enum PidFile {
    private static func path() throws -> String {
        guard let user = ProcessInfo.processInfo.environment["USER"] else {
            throw PidFileError.missingEnvVarUser
        }

        return FileManager
            .default
            .temporaryDirectory
            .appendingPathComponent("skbd_\(user).pid", isDirectory: false)
            .path
    }

    public static func create() throws {
        let handle = open(try path(), O_CREAT | O_WRONLY, 0o600)

        if handle == -1 {
            throw PidFileError.failedToOpenFile
        }

        var lockfd = flock()
        lockfd.l_start = 0
        lockfd.l_len = 0
        lockfd.l_pid = getpid()
        lockfd.l_type = Int16(F_WRLCK)
        lockfd.l_whence = Int16(SEEK_SET)

        if fcntl(handle, F_SETLK, &lockfd) == -1 {
            throw PidFileError.failedToLockFile
        }

        var pid = getpid()

        if write(handle, &pid, MemoryLayout<pid_t>.size) == -1 {
            throw PidFileError.failedToWriteFile
        }
    }

    public static func read() throws -> pid_t {
        let handle = open(try path(), O_RDWR)

        if handle == -1 {
            throw PidFileError.failedToOpenFile
        }

        if flock(handle, LOCK_EX | LOCK_NB) == 0 {
            throw PidFileError.failedToLockFile
        }

        var pid: pid_t = 0

        if Darwin.read(handle, &pid, MemoryLayout<pid_t>.size) == -1 {
            throw PidFileError.failedToReadFile
        }

        close(handle)

        return pid
    }
}
