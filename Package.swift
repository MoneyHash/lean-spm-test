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
            path: "../moneyhashCore-spm"
        ),
        .package(
            url: "https://github.com/leantechnologies/link-sdk-ios-distribution",
            exact: "3.0.19"
        )
    ],
    targets: [
        .target(
            name: "MoneyHashLeanSDK",
            dependencies: [
                .target(name: "moeyhashleantest"),
                .product(name: "MoneyHashCore", package: "MoneyHashCore"),
                .product(name: "LeanSDK", package: "link-sdk-ios-distribution")
            ]
        ),
        .binaryTarget(
            name: "moeyhashleantest",
            path: "Sources/Frameworks/MoneyHashLean.xcframework"
        )
    ]
)
