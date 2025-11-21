import SwiftUI
import WindowOverlay

extension View {
  /// Installs the toast presentation system on this view.
  ///
  /// This modifier should be applied to a parent view in the hierarchy to enable toast
  /// notifications in all child views. Child views can then present toasts using the
  /// `presentToast` environment value.
  ///
  /// - Parameters:
  ///   - position: The vertical position where toasts will appear. Default is `.bottom`.
  ///   - haptics: Whether to enable haptic feedback for toasts. Default is `false`.
  /// - Returns: A view with toast presentation capability.
  public func installToast(position: ToastPosition = .bottom, haptics: Bool = false) -> some View {
    self.modifier(InstallToastModifier(position: position, haptics: haptics))
  }
}

private struct InstallToastModifier: ViewModifier {
  var position: ToastPosition
  var haptics: Bool
  @State private var manager = ToastManager()
  func body(content: Content) -> some View {
    content
      .environment(
        \.presentToast,
        PresentToastAction(manager: manager)
      )
      ._background {
        InstallToastView(manager: manager)
      }
      ._onChange(of: position, initial: true) {
        manager.position = $1
      }
      ._onChange(of: haptics, initial: true) {
        manager.haptics = $1
      }
      .addToastSafeAreaObserver()
      .onPreferenceChange(SafeAreaInsetsPreferenceKey.self) {
        manager.safeAreaInsets = $0
      }
  }
}

private struct InstallToastView: View {
  @ObservedObject var manager: ToastManager
  var body: some View {
    Color.clear
      .windowOverlay(isPresented: manager.isPresented, disableSafeArea: true) {
        ToastRootView(manager: manager)
      }
  }
}

extension View {
  /// Adds a notifier for safe area insets that the toast system can use for proper positioning.
  ///
  /// This is an internal helper method used by the toast system.
  public func addToastSafeAreaObserver() -> some View {
    self._background {
      GeometryReader { geometry in
        Color.clear
          .preference(key: SafeAreaInsetsPreferenceKey.self, value: geometry.safeAreaInsets)
      }
    }
  }
}

private enum SafeAreaInsetsPreferenceKey: PreferenceKey {
  static let defaultValue: EdgeInsets = .init()
  static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
    let next = nextValue()
    value = EdgeInsets(
      top: max(value.top, next.top),
      leading: max(value.leading, next.leading),
      bottom: max(value.bottom, next.bottom),
      trailing: max(value.trailing, next.trailing))
  }
}
