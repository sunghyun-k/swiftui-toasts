import SwiftUI

extension View {
  public func windowOverlay<V: View>(
    isPresented: Bool,
    disableSafeArea: Bool = false,
    @ViewBuilder content: () -> V
  ) -> some View {
    self._background {
      WindowBridgingView(
        isPresented: isPresented, disableSafeArea: disableSafeArea, content: content()
      )
      .allowsHitTesting(false)
    }
  }
}

