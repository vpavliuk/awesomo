// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "PeerDiscovery",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v16),
   ],
   products: [
      .library(
         name: "PeerDiscovery",
         targets: ["PeerDiscovery"]
      ),
   ],
   dependencies: [
      .package(path: "../MessagingApp"),
      .package(path: "../BonjourBrowser"),
      .package(path: "../TestUtils"),
   ],
   targets: [
      .target(
         name: "PeerDiscovery",
         dependencies: [
            "MessagingApp",
            "BonjourBrowser",
         ]
      ),
      .testTarget(
         name: "PeerDiscoveryTests",
         dependencies: [
            "PeerDiscovery",
            "MessagingApp",
            "TestUtils",
         ]
      ),
   ]
)
