// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "hackscode",
    dependencies: [
        .package(url: "https://github.com/toshi0383/xcodeproj", .branch("instruments-package")),
        .package(url: "https://github.com/toshi0383/CoreCLI", from: "0.1.10"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
    ],
    targets: [
        .target(name: "hackscode", dependencies: ["xcodeproj", "CoreCLI", "ShellOut"]),
    ]
)
