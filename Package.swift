// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "lox-swift",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "lox",
            dependencies: ["LoxCore"],
            path: "Sources/lox"
        ),
        .target(
            name: "LoxCore",
            path: "Sources/LoxCore"
        ),
        .testTarget(
            name: "LoxCoreTests",
            dependencies: ["LoxCore"],
            path: "Tests/LoxCoreTests"
        ),
    ]
)
