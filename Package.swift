// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Estatus",
    dependencies: [
      .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Estatus",
            dependencies: ["Console", "Command"]),
        .testTarget(
            name: "EstatusTests",
            dependencies: ["Estatus"]),
    ]
)
