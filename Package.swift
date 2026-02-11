// swift-tools-version: 6.0.0

import PackageDescription

let package = Package(
    name: "FirebaseProvider",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FirebaseProvider",
            targets: ["FirebaseProvider"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            exact: "12.9.0"
        ),
        .package(
            url: "https://github.com/wedobooks/wedobooks-sdk-ios-firebase-interfaces.git",
            from: "1.1.2"
        )
    ],
    targets: [
        .target(
            name: "FirebaseProvider",
            dependencies: [
                .product(name: "WDBFirebaseInterfaces", package: "wedobooks-sdk-ios-firebase-interfaces"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFunctions", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
            ]
        ),
        .testTarget(
            name: "FirebaseProviderTests",
            dependencies: ["FirebaseProvider"]
        )
    ]
)
