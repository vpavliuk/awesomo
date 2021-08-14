// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "TCPTransfer",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13),
   ],
   products: [
      .library(
         name: "TCPTransfer",
         targets: ["TCPTransfer"]
      ),
   ],
   dependencies: [
      // Foundation
      // Network
      // Combine
      .package(path: "../Utils"),
   ],
   targets: [
      .target(
         name: "TCPTransfer",
         dependencies: ["Utils"]
      ),
      .testTarget(
         name: "TCPTransferTests",
         dependencies: ["TCPTransfer"]
      ),
   ]
)
