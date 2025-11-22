// swift-tools-version: 6.1
import PackageDescription

let package = Package(
  name: "toast-alerts",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "Toasts",
      targets: ["Toasts"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Toasts",
      dependencies: [],
      path: "Sources/Toast"
    ),
    .testTarget(
      name: "ToastManagerTests",
      dependencies: ["Toasts"]
    ),
  ]
)
