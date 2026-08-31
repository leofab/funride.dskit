// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FDSDKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "FDSDKit",
            targets: ["FDSDKit"]
        )
    ],
    targets: [
        .target(
            name: "FDSDKit",
            path: "Sources/FDSDKit"
        ),
        .testTarget(
            name: "FDSDKitTests",
            dependencies: ["FDSDKit"],
            path: "Tests/FDSDKitTests"
        )
    ]
)
