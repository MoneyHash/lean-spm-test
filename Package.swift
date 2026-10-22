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
            .exact("0.0.4-beta.3")
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
            url: "https://github.com/MoneyHash/lean-spm-test/releases/download/0.0.2-dev.2/MoneyHashLean.xcframework.zip",
            checksum: "616fe57562756b6a734fac36eaa964b143020fb607a255dc312bcec1c14ae596"
        )
    ]
)
