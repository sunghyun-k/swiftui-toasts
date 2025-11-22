import struct SwiftUI.Color
#if os(iOS)
import class UIKit.UIColor

extension UIColor {
  internal convenience init(light: UIColor, dark: UIColor) {
    self.init { $0.userInterfaceStyle == .dark ? dark : light }
  }
}
#endif

extension Color {
  internal init(light: Color, dark: Color) {
    #if os(iOS)
    self.init(_uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    #else
    self = light
    #endif
  }
}

extension Color {
  internal static let toastBackground: Color = Color(light: .white, dark: Color(white: 0.12))
}
