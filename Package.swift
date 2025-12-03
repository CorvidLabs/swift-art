// swift-tools-version: 6.0

import PackageDescription

var products: [Product] = [
    .library(
        name: "Art",
        targets: ["Art"]
    ),
    .library(
        name: "ArtTerminal",
        targets: ["ArtTerminal"]
    )
]

var targets: [Target] = [
    .target(
        name: "Art",
        dependencies: [
            .product(name: "Color", package: "swift-color"),
        ]
    ),
    .target(
        name: "ArtTerminal",
        dependencies: ["Art"]
    ),
    .testTarget(
        name: "ArtTests",
        dependencies: ["Art"]
    ),
    .testTarget(
        name: "ArtTerminalTests",
        dependencies: ["ArtTerminal"]
    )
]

#if canImport(SwiftUI)
products.append(.library(name: "ArtUI", targets: ["ArtUI"]))
targets.append(.target(name: "ArtUI", dependencies: ["Art"]))
targets.append(.testTarget(name: "ArtUITests", dependencies: ["ArtUI"]))
#endif

let package = Package(
    name: "swift-art",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/CorvidLabs/swift-color.git", from: "0.1.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3")
    ],
    targets: targets
)
