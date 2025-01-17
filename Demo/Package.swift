// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [
        .macOS(.v12), .iOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(name: "Demo", targets: ["Demo"])
    ],
    dependencies: [.package(path: "..")],
    targets: [
        .target(name: "Demo", dependencies: ["CompactSlider"])
    ]
)
