import SwiftUI

extension EnvironmentValues {
  public internal(set) var presentToast: PresentToastAction {
    get { self[PresentToastKey.self] }
    set { self[PresentToastKey.self] = newValue }
  }
}

public struct PresentToastAction {
  internal weak var _manager: ToastManager?
  private var manager: ToastManager {
    guard let _manager else {
      fatalError("View.installToast must be called on a parent view to use EnvironmentValues.presentToast.")
    }
    return _manager
  }

  @MainActor
  public func callAsFunction(_ toast: ToastValue) {
    manager.append(toast)
  }

  public func callAsFunction<V>(
    message: String,
    task: () async throws -> V,
    onSuccess: (V) -> ToastValue,
    onFailure: (any Error) -> ToastValue
  ) async throws -> V {
    try await manager.append(
      message: message,
      task: task,
      onSuccess: onSuccess,
      onFailure: onFailure
    )
  }
}

private enum PresentToastKey: EnvironmentKey {
  static let defaultValue: PresentToastAction = .init()
}
