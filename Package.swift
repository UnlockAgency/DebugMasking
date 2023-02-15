// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DebugMasking",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "DebugMasking", targets: ["DebugMasking"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "DebugMasking", path: "Sources"),
        .testTarget(
            name: "DebugMaskingTests",
            dependencies: [
                "DebugMasking"
            ],
            path: "TestSources"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
