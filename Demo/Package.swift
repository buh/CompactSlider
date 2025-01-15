// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [
        .macOS(.v11), .iOS(.v14), .watchOS(.v7)
    ],
    products: [
        .library(name: "Demo", targets: ["Demo"])
    ],
    dependencies: [.package(path: "..")],
    targets: [
        .target(name: "Demo", dependencies: ["CompactSlider"])
    ]
)
