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
    .package(url: "https://github.com/Rabithua/swiftui-window-overlay.git", branch: "codex/liquid-glass-toasts")
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
