// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "klarna_flutter_pay",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "klarna-flutter-pay", targets: ["klarna_flutter_pay"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Mirrors the `~> 2.7.1` constraint in klarna_flutter_pay.podspec.
        .package(
            url: "https://github.com/klarna/klarna-mobile-sdk-spm.git",
            .upToNextMinor(from: "2.7.1")
        )
    ],
    targets: [
        .target(
            name: "klarna_flutter_pay",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-spm")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
