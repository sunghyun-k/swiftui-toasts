import SwiftUI
import WindowOverlay

extension View {
  public func installToast(
    position: ToastPosition = .bottom,
    order: ToastOrder = .fifo
  ) -> some View {
    self.modifier(InstallToastModifier(position: position, order: order))
  }
}

private struct InstallToastModifier: ViewModifier {
  var position: ToastPosition
  var order: ToastOrder
  @State private var manager = ToastManager()
  func body(content: Content) -> some View {
    content
      .environment(
        \.presentToast,
        PresentToastAction(_manager: manager)
      )
      ._background {
        InstallToastView(manager: manager)
      }
      ._onChange(of: position, initial: true) {
        manager.position = $1
      }
      ._onChange(of: order, initial: true) {
        manager.order = $1
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
