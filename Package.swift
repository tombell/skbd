// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "skbd",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "skbd",
            dependencies: ["skbdlib"]),
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
