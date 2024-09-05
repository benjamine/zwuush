// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "zwuush",
    platforms: [
        .macOS(.v12), // Specify macOS 12 or later for SwiftUI support
    ],
    products: [
        .executable(name: "zwuush", targets: ["zwuush"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "zwuush"
        ),
    ]
)
