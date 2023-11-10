// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "Domain",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v14)
   ],
   products: [
      .library(
         name: "Domain",
         targets: ["Domain"]
      ),
   ],
   dependencies: [
      // Foundation
      // Combine
   ],
   targets: [
      .target(
         name: "Domain",
         dependencies: []
      ),
      .testTarget(
         name: "DomainTests",
         dependencies: ["Domain"]
      ),
   ]
)
