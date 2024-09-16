import XCTest
@testable import Toast

@MainActor
final class ToastManagerTests: XCTestCase {
  func testAppendToast() {
    let manager = ToastManager()
    let toast = ToastModel(message: "Test Message")

    manager.append(toast)

    XCTAssertEqual(manager.toasts.count, 1)
    XCTAssertEqual(manager.toasts.first, toast)
  }

  func testRemoveToast() {
    let manager = ToastManager()
    let toast = ToastModel(message: "Test Message")

    manager.append(toast)
    manager.remove(toast)

    XCTAssertTrue(manager.toasts.isEmpty)
  }

  func testIsPresented() {
    let manager = ToastManager()

    XCTAssertFalse(manager.isPresented)

    let toast = ToastModel(message: "Test Message")
    manager.append(toast)

    XCTAssertTrue(manager.isPresented)
  }

  func testStartRemovalTask() async throws {
    let manager = ToastManager()
    manager.duration = 0.1
    let toast = ToastModel(message: "Test Message")

    manager.append(toast)
    try await manager.startRemovalTask(for: toast)

    XCTAssertFalse(manager.toasts.contains(toast))
  }

  func testDismissOverlayTask() async throws {
    let manager = ToastManager()
    manager.duration = 0.1
    let toast = ToastModel(message: "Test Message")

    manager.append(toast)
    manager.onAppear()

    XCTAssertTrue(manager.isAppeared)

    manager.remove(toast)

    XCTAssertTrue(manager.toasts.isEmpty)

    try await Task.sleep(seconds: removalAnimationDuration + 0.1)

    XCTAssertFalse(manager.isAppeared)
  }
}
