// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "skbd",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "skbd",
            dependencies: ["skbdlib", "ArgumentParser"]),
        .target(
            name: "skbdlib",
            dependencies: []),
        .testTarget(
            name: "skbdTests",
            dependencies: ["skbd"]),
        .testTarget(
            name: "skbdlibTests",
            dependencies: ["skbdlib"]),
    ]
)
