// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "MessagingApp",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13)
   ],
   products: [
      .library(
         name: "MessagingApp",
         targets: ["MessagingApp"]
      ),
   ],
   dependencies: [
      .package(path: "../Domain"),
      .package(path: "../Utils"),
   ],
   targets: [
      .target(
         name: "MessagingApp",
         dependencies: [
            "Domain",
            "Utils",
         ]
      ),
      .testTarget(
         name: "MessagingAppTests",
         dependencies: ["MessagingApp"]
      ),
   ]
)
