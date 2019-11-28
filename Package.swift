// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "hackscode",
    products: [
        .executable(name: "hackscode", targets: ["hackscode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/toshi0383/CoreCLI", .upToNextMajor(from: "0.1.10")),
        .package(url: "https://github.com/tuist/XcodeProj", .upToNextMajor(from: "7.1.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut", .upToNextMajor(from: "2.2.0")),
    ],
    targets: [
        .target(name: "hackscode", dependencies: ["CoreCLI", "XcodeProj", "ShellOut"]),
    ]
)
