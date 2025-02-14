// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Demo",
    platforms: [
        .macOS(.v12), .iOS(.v15), .watchOS(.v8), .visionOS(.v1)
    ],
    products: [
        .library(name: "Demo", targets: ["Demo"])
    ],
    dependencies: [.package(path: "..")],
    targets: [
        .target(name: "Demo", dependencies: ["CompactSlider"])
    ],
    swiftLanguageVersions: [.v5]
)
