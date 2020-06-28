// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "skbd",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "skbd",
            dependencies: [
                "skbdlib",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
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
