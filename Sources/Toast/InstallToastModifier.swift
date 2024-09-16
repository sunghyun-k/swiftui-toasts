import SwiftUI
import WindowOverlay

extension View {
  public func installToast() -> some View {
    self.modifier(InstallToastModifier())
  }
}

private struct InstallToastModifier: ViewModifier {
  @State private var manager = ToastManager()
  func body(content: Content) -> some View {
    content
      .environment(
        \.presentToast,
        PresentToastAction(action: { manager.append($0) })
      )
      ._background {
        InstallToastView(manager: manager)
      }
  }
}

private struct InstallToastView: View {
  @ObservedObject var manager: ToastManager
  var body: some View {
    if manager.isPresented {
      Color.clear
        .windowOverlay(isPresented: true) {
          ToastRootView(manager: manager)
        }
    }
  }
}
