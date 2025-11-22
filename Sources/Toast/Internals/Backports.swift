import SwiftUI
#if os(iOS)
import UIKit
#endif

extension View {
  @ViewBuilder
  nonisolated internal func _background(
    alignment: Alignment = .center,
    @ViewBuilder content: () -> some View
  ) -> some View {
    if #available(iOS 15.0, macOS 12.0, *) {
      self.background(alignment: alignment, content: content)
    } else {
      self.background(content(), alignment: alignment)
    }
  }

  @ViewBuilder
  internal func _foregroundColor(_ color: Color) -> some View {
    if #available(iOS 15.0, macOS 12.0, *) {
      self.foregroundStyle(color)
    } else {
      self.foregroundColor(color)
    }
  }

  @ViewBuilder
  internal func _onChange<V: Equatable>(
    of value: V,
    initial: Bool = false,
    _ action: @escaping (_ oldValue: V, _ newValue: V) -> Void
  ) -> some View {
    if #available(iOS 17.0, macOS 14.0, *) {
      self.onChange(of: value, initial: initial, action)
    } else {
      self
        .onAppear {
          if initial { action(value, value) }
        }
        .onChange(of: value) { [oldValue = value] newValue in
          action(oldValue, newValue)
        }
    }
  }
}

extension Task where Success == Never, Failure == Never {
  static func sleep(seconds: Double) async throws {
    if #available(iOS 16.0, macOS 13.0, *) {
      try await sleep(for: .seconds(seconds))
    } else {
      try await sleep(nanoseconds: UInt64(seconds * 1000) * NSEC_PER_MSEC)
    }
  }
}

extension Color {
  #if os(iOS)
  internal init(_uiColor uiColor: UIColor) {
    if #available(iOS 15.0, *) {
      self.init(uiColor: uiColor)
    } else {
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      // Note: This resolves the dynamic color to the current trait collection immediately.
      // On iOS 14, Color cannot wrap a dynamic UIColor directly.
      uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      self.init(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
  }
  #endif
}
