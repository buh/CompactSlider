// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CompactSlider",
    platforms: [
        .macOS(.v12), .iOS(.v15), .watchOS(.v8), .visionOS(.v1)
    ],
    products: [
        .library(name: "CompactSlider", targets: ["CompactSlider"])
    ],
    targets: [
        .target(name: "CompactSlider", resources: [.process("PrivacyInfo.xcprivacy")])
    ]
)
