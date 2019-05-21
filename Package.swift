// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "hackscode",
    products: [
        .executable(name: "hackscode", targets: ["hackscode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/toshi0383/xcodeproj", .branch("ts-426-safe-dictionary")),
        .package(url: "https://github.com/toshi0383/CoreCLI", from: "0.1.10"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
    ],
    targets: [
        .target(name: "hackscode", dependencies: ["xcodeproj", "CoreCLI", "ShellOut"]),
    ]
)
