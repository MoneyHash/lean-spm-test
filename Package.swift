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
            "0.0.6-dev.4"..<"1.0.0"
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
            url: "https://github.com/MoneyHash/lean-spm-test/releases/download/0.0.6-dev.4/MoneyHashLean.xcframework.zip",
            checksum: "2843150a149e9490b6d0701423ce942ab6f82e7eca23ea1916c5eb89d76c2c5c"
        )
    ]
)
