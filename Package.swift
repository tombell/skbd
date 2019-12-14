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
            dependencies: ["skbdLib"]),
        .target(
            name: "skbdLib",
            dependencies: []),
        .testTarget(
            name: "skbdTests",
            dependencies: ["skbd"]),
        .testTarget(
            name: "skbdLibTests",
            dependencies: ["skbdLib"]),
    ]
)
