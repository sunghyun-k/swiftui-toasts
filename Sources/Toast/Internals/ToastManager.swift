import SwiftUI

@MainActor
internal final class ToastManager: ObservableObject {

  @Published internal var position: ToastPosition = .top
  @Published internal private(set) var models: [ToastModel] = []
  @Published internal private(set) var isAppeared = false
  private var dismissOverlayTask: Task<Void, any Error>?

  internal var isPresented: Bool {
    !models.isEmpty || isAppeared
  }

  nonisolated init() {}

  internal func onAppear() {
    isAppeared = true
  }

  @discardableResult
  internal func append(_ toast: ToastValue) -> ToastModel {
    dismissOverlayTask?.cancel()
    dismissOverlayTask = nil
    let model = ToastModel(value: toast)
    models.append(model)
    return model
  }

  internal func remove(_ model: ToastModel) {
    if let index = self.models.firstIndex(where: { $0 === model }) {
      self.models.remove(at: index)
    }
    if models.isEmpty {
      dismissOverlayTask = Task {
        try await Task.sleep(seconds: removalAnimationDuration)
        isAppeared = false
      }
    }
  }

  internal func startRemovalTask(for model: ToastModel) async {
    if let duration = model.value.duration {
      do {
        try await Task.sleep(seconds: duration)
        remove(model)
      } catch {}
    }
  }

  @discardableResult
  internal func append<V>(
    message: String,
    task: () async throws -> V,
    onSuccess: (V) -> ToastValue,
    onFailure: (any Error) -> ToastValue
  ) async throws -> V {
    let model = append(ToastValue(icon: LoadingView(), message: message, duration: nil))
    do {
      let value = try await task()
      withAnimation(.spring) {
        model.value = onSuccess(value)
      }
      return value
    } catch {
      withAnimation(.spring) {
        model.value = onFailure(error)
      }
      throw error
    }
  }
}

internal let removalAnimationDuration: Double = 0.3
