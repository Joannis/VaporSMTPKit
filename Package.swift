// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VaporSMTPKit",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "VaporSMTPKit",
            targets: ["VaporSMTPKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Joannis/SMTPKitten.git", "0.2.0" ..< "0.2.3"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "VaporSMTPKit",
            dependencies: [
                .product(name: "SMTPKitten", package: "SMTPKitten"),
                .product(name: "Vapor", package: "vapor"),
            ]),
    ]
)
