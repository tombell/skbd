import class Foundation.Bundle
import XCTest

final class skbdTests: XCTestCase {
    func testExample() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let skbdBinary = productsDirectory.appendingPathComponent("skbd")

        let process = Process()
        process.executableURL = skbdBinary
        process.arguments = ["--arg1", "--arg2"]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        let expected = [
            "Hello, world!",
            "arg: \(skbdBinary.path)",
            "arg: --arg1",
            "arg: --arg2",
        ].joined(separator: "\n")

        XCTAssertEqual(output, expected + "\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("couldn't find the products directory")
        #else
            return Bundle.main.bundleURL
        #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
