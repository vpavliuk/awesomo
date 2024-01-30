// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "TCPListener",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13),
   ],
   products: [
      .library(
         name: "TCPListener",
         targets: ["TCPListener"]
      ),
   ],
   targets: [
      .target(name: "TCPListener"),
      .testTarget(
         name: "TCPListenerTests",
         dependencies: ["TCPListener"]
      ),
   ]
)
