// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "StretchyHeaderUI",
    products: [
        .library(name: "StretchyHeaderUI", targets: ["StretchyHeaderUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "StretchyHeaderUI"),
        .testTarget(name: "StretchyHeaderUITests", dependencies: ["StretchyHeaderUI"])
    ],
    swiftLanguageModes: [.v6]
)
