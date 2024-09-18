import XCTest
import SwiftUI
@testable import Toasts

@MainActor
final class ToastManagerTests: XCTestCase {
  func testAppendToast() {
    let manager = ToastManager()
    let toast = ToastValue(message: "Test Message")
    
    let model = manager.append(toast)
    
    XCTAssertEqual(manager.models.count, 1)
    XCTAssertTrue(manager.models.contains(where: { $0 === model }))
    XCTAssertEqual(model.message, "Test Message")
  }
  
  func testRemoveToast() {
    let manager = ToastManager()
    let toast = ToastValue(message: "Test Message")
    let model = manager.append(toast)
    
    manager.remove(model)
    
    XCTAssertTrue(manager.models.isEmpty)
  }
  
  func testIsPresented() {
    let manager = ToastManager()
    
    XCTAssertFalse(manager.isPresented)
    
    let toast = ToastValue(message: "Test Message")
    manager.append(toast)
    
    XCTAssertTrue(manager.isPresented)
  }
  
  func testOnAppear() {
    let manager = ToastManager()
    
    XCTAssertFalse(manager.isAppeared)
    
    manager.onAppear()
    
    XCTAssertTrue(manager.isAppeared)
  }
  
  func testStartRemovalTask() async {
    let manager = ToastManager()
    let toast = ToastValue(message: "Test Message", duration: 0.1)
    let model = manager.append(toast)
    
    await manager.startRemovalTask(for: model)
    
    XCTAssertTrue(manager.models.isEmpty)
  }
  
  func testAppendWithTask() async throws {
    let manager = ToastManager()
    
    let result = try await manager.append(
      message: "Loading...",
      task: {
        try await Task.sleep(seconds: 0.1)
        return "Success"
      },
      onSuccess: { result in
        ToastValue(icon: Image(systemName: "checkmark.circle"), message: result)
      },
      onFailure: { error in
        ToastValue(icon: Image(systemName: "xmark.circle"), message: error.localizedDescription)
      }
    )
    
    XCTAssertEqual(result, "Success")
    XCTAssertEqual(manager.models.count, 1)
    XCTAssertEqual(manager.models.first?.message, "Success")
  }

  func testAppendWithErrorTask() async throws {
    let manager = ToastManager()

    do {
      try await manager.append(
        message: "Loading...",
        task: {
          try await Task.sleep(seconds: 0.1)
          throw NSError(domain: "", code: 0)
        },
        onSuccess: { result in
          ToastValue(icon: Image(systemName: "checkmark.circle"), message: result)
        },
        onFailure: { error in
          ToastValue(icon: Image(systemName: "xmark.circle"), message: "Error")
        }
      )
    } catch {}
    XCTAssertEqual(manager.models.count, 1)
    XCTAssertEqual(manager.models.first?.message, "Error")
  }
}
