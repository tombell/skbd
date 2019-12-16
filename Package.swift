// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "skbd",
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
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
