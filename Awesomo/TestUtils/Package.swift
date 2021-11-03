// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "TestUtils",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13)
   ],
   products: [
      .library(
         name: "TestUtils",
         targets: ["TestUtils"]
      ),
   ],
   dependencies: [
      // Foundation
      // Combine
      .package(path: "../Utils")
   ],
   targets: [
      .target(
         name: "TestUtils",
         dependencies: ["Utils"]
      ),
      .testTarget(
         name: "TestUtilsTests",
         dependencies: ["TestUtils"]
      ),
   ]
)
