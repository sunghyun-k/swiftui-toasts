import SwiftUI

@MainActor
internal final class ToastManager: ObservableObject {

  internal var duration: Double = 3.0
  @Published internal private(set) var toasts: [ToastModel] = []
  @Published internal private(set) var isAppeared = false
  private var dismissOverlayTask: Task<Void, any Error>?

  internal var isPresented: Bool {
    !toasts.isEmpty || isAppeared
  }

  nonisolated init() {}

  internal func onAppear() {
    isAppeared = true
  }

  internal func append(_ toast: ToastModel) {
    dismissOverlayTask?.cancel()
    dismissOverlayTask = nil
    toasts.append(toast)
  }

  internal func remove(_ toast: ToastModel) {
    if let index = self.toasts.firstIndex(of: toast) {
      self.toasts.remove(at: index)
    }
    if toasts.isEmpty {
      dismissOverlayTask = Task {
        try await Task.sleep(seconds: removalAnimationDuration)
        isAppeared = false
      }
    }
  }

  internal func startRemovalTask(for toast: ToastModel) async throws {
    try await Task.sleep(seconds: duration)
    remove(toast)
  }
}

internal let removalAnimationDuration: Double = 0.3
