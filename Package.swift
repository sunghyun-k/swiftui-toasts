// swift-tools-version: 6.1
import PackageDescription

let package = Package(
  name: "swiftui-toasts",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "Toasts",
      targets: ["Toasts"])
  ],
  dependencies: [
    .package(url: "https://github.com/sunghyun-k/swiftui-window-overlay.git", from: "1.0.2")
  ],
  targets: [
    .target(
      name: "Toasts",
      dependencies: [
        .product(name: "WindowOverlay", package: "swiftui-window-overlay")
      ]
    ),
    .testTarget(
      name: "ToastManagerTests",
      dependencies: ["Toasts"]
    ),
  ]
)
