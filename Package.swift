// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DangerSpikeLib",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "DangerSpikeLib", targets: ["DangerSpikeLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "DangerSpikeLib", dependencies: [
            .product(name: "Collections", package: "swift-collections")
        ]),
        .testTarget(name: "DangerSpikeLibTests", dependencies: ["DangerSpikeLib"]),
    ]
)
