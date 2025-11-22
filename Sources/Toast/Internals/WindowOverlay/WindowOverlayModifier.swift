import SwiftUI

extension View {
  public func windowOverlay<V: View>(
    isPresented: Bool,
    disableSafeArea: Bool = false,
    @ViewBuilder content: () -> V
  ) -> some View {
    #if os(iOS)
    self._background {
      WindowBridgingView(
        isPresented: isPresented, disableSafeArea: disableSafeArea, content: content()
      )
      .allowsHitTesting(false)
    }
    #else
    self.overlay(
      Group {
        if isPresented {
          content()
        }
      }
    )
    #endif
  }
}
