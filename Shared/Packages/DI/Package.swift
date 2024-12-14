// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "DI", targets: ["DI"])
    ],
    targets: [
        .target(
            name: "DI"
        ),
        .testTarget(
            name: "DITests"
        )
    ]
)
