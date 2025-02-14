// swift-tools-version: 5.9

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
    ],
    swiftLanguageVersions: [.v5]
)
