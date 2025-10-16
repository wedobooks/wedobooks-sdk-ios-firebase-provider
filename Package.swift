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
            exact: "11.13.0"
        ),
    ],
    targets: [
        .target(
            name: "FirebaseProvider",
            dependencies: [
                "WDBFirebaseInterfaces",
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
        ),
        .binaryTarget(
            name: "WDBFirebaseInterfaces",
            url: "https://wdb-ios-spm-844218222632.europe-west1.run.app/WDBFirebaseInterfaces-v1.0.0.xcframework.zip",
            checksum: "2e9b237fce9bbe23213356b14469ede484b1b0619e28920379bed325364cc056"
        )
    ]
)
