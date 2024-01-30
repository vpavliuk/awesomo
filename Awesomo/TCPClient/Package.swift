// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "TCPClient",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13),
   ],
   products: [
      .library(
         name: "TCPClient",
         targets: ["TCPClient"]
      ),
   ],
   targets: [
      .target(name: "TCPClient"),
      .testTarget(
         name: "TCPClientTests",
         dependencies: ["TCPClient"]
      ),
   ]
)
