import SwiftUI

extension EnvironmentValues {
  public internal(set) var presentToast: PresentToastAction {
    get { self[PresentToastKey.self] }
    set { self[PresentToastKey.self] = newValue }
  }
}

public struct PresentToastAction {
  internal var action: (ToastModel) -> () = { _ in
    print("View.installToast must be called on a parent view to use EnvironmentValues.presentToast.")
  }
  public func callAsFunction(_ model: ToastModel) {
    action(model)
  }
}

private enum PresentToastKey: EnvironmentKey {
  static let defaultValue: PresentToastAction = .init()
}
