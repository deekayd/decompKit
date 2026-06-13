// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DecompKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "DecompKit",
            targets: ["DecompKit"]
        )
    ],
    targets: [
        .target(name: "DecompKit"),
        .testTarget(
            name: "DecompKitTests",
            dependencies: ["DecompKit"]
        )
    ]
)
