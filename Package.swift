// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MoneyHashLeanSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "MoneyHashLeanSDK",
            targets: ["MoneyHashLeanSDK"]
        ),
    ],
    dependencies: [
        .package(
            name: "MoneyHashCore",
            url: "https://github.com/MoneyHash/core-ios-test-spm.git",
            "0.0.6"..<"1.0.0"
        ),
        .package(
            url: "https://github.com/leantechnologies/link-sdk-ios-distribution",
            exact: "3.0.23"
        )
    ],
    targets: [
        .target(
            name: "MoneyHashLeanSDK",
            dependencies: [
                .target(name: "MoneyHashLean"),
                .product(name: "MoneyHashCore", package: "MoneyHashCore"),
                .product(name: "LeanSDK", package: "link-sdk-ios-distribution")
            ]
        ),
        .binaryTarget(
            name: "MoneyHashLean",
            url: "https://github.com/MoneyHash/lean-spm-test/releases/download/0.0.6/MoneyHashLean.xcframework.zip",
            checksum: "1a753d090d5f355c45c3d249a57a2c66d4aba3e149a62829b8a100ea1c55edbf"
        )
    ]
)
