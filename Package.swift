// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "hackscode",
    dependencies: [
        .package(url: "https://github.com/xcode-project-manager/xcodeproj", .branchItem("master")),
    ],
    targets: [
        .target(name: "hackscode", dependencies: ["xcodeproj", "CoreCLI"]),
        .target(name: "CoreCLI", dependencies: [], exclude: ["Sources/CoreCLI/AutoCommandOptionDecodables.swifttemplate"]),
    ]
)
