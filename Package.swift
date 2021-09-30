// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QuickApi",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v11),
  ],
  products: [
    .library(
      name: "QuickApi",
      targets: ["QuickApi"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
  ],
  targets: [
    .target(
      name: "QuickApi",
      dependencies: ["Alamofire"]),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)
