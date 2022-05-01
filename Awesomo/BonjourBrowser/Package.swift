// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "BonjourBrowser",
   platforms: [
      .macOS(.v10_15),
      .iOS(.v13),
   ],
   products: [
      .library(
         name: "BonjourBrowser",
         targets: ["BonjourBrowser"]
      ),
   ],
   dependencies: [
   ],
   targets: [
      .target(
         name: "BonjourBrowser",
         dependencies: []
      ),
      .testTarget(
         name: "BonjourBrowserTests",
         dependencies: ["BonjourBrowser"]
      ),
   ]
)
