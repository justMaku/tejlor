// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Taylor",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/BlueSocket", majorVersion: 0, minor: 12)
    ]
)
