// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-art",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Art",
            targets: ["Art"]
        ),
        .library(
            name: "ArtUI",
            targets: ["ArtUI"]
        ),
        .library(
            name: "ArtTerminal",
            targets: ["ArtTerminal"]
        ),
        .executable(
            name: "ArtDemo",
            targets: ["ArtDemo"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3")
    ],
    targets: [
        .target(name: "Art"),
        .target(
            name: "ArtUI",
            dependencies: ["Art"]
        ),
        .target(
            name: "ArtTerminal",
            dependencies: ["Art"]
        ),
        .executableTarget(
            name: "ArtDemo",
            dependencies: ["Art", "ArtUI", "ArtTerminal"]
        ),
        .testTarget(
            name: "ArtTests",
            dependencies: ["Art"]
        ),
        .testTarget(
            name: "ArtUITests",
            dependencies: ["ArtUI"]
        ),
        .testTarget(
            name: "ArtTerminalTests",
            dependencies: ["ArtTerminal"]
        )
    ]
)
