// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToastView",
    platforms: [
        .iOS(.v13) // Adjust this version based on the minimum iOS version your package supports.
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ToastView",
            targets: ["ToastView"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ToastView"
        ),
        .testTarget(
            name: "ToastViewTests",
            dependencies: ["ToastView"]),
    ]
)

