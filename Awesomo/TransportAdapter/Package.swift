// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "TransportAdapter",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13)
   ],
   products: [
      .library(
         name: "TransportAdapter",
         targets: ["TransportAdapter"]
      ),
   ],
   dependencies: [
      .package(path: "../Domain"),
      .package(path: "../MessagingApp"),
      .package(path: "../TCPTransfer"),
      .package(path: "../Utils"),
      // Combine
      // Foundation
   ],
   targets: [
      .target(
         name: "TransportAdapter",
         dependencies: [
            "Domain",
            "MessagingApp",
            "TCPTransfer",
            "Utils",
         ]
      ),
      .testTarget(
         name: "TransportAdapterTests",
         dependencies: [
            "TransportAdapter",
            "Domain",
            "MessagingApp",
         ]
      ),
   ]
)
