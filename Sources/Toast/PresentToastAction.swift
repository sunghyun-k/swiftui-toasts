import SwiftUI

extension EnvironmentValues {
  /// Provides access to the toast presentation action within the environment.
  ///
  /// This value is only available after calling `installToast()` on a parent view in the hierarchy.
  public internal(set) var presentToast: PresentToastAction {
    get { self[PresentToastKey.self] }
    set { self[PresentToastKey.self] = newValue }
  }
}

/// Represents an action for presenting toast messages in SwiftUI views.
public struct PresentToastAction {
  internal weak var _manager: ToastManager?
  private var manager: ToastManager {
    guard let _manager else {
      fatalError(
        "View.installToast must be called on a parent view to use EnvironmentValues.presentToast.")
    }
    return _manager
  }

  /// Presents a toast with the specified configuration.
  ///
  /// - Parameter toast: The toast configuration to display.
  @MainActor
  public func callAsFunction(_ toast: ToastValue) {
    manager.append(toast)
  }

  /// Presents a loading toast that automatically updates based on the result of an asynchronous task.
  ///
  /// - Parameters:
  ///   - message: The loading message to display while the task is in progress.
  ///   - task: The asynchronous task to execute.
  ///   - onSuccess: A closure that returns a toast to display when the task succeeds.
  ///   - onFailure: A closure that returns a toast to display when the task fails.
  /// - Returns: The result of the asynchronous task.
  /// - Throws: Any error thrown by the asynchronous task.
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
