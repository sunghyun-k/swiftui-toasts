import Foundation

import struct SwiftUI.Image
import struct SwiftUI.Color

public struct ToastValue {
  internal var icon: Image?
  internal var message: String
  internal var button: ToastButton?
  internal var duration: TimeInterval?
  public init(
    icon: Image? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0
  ) {
    self.icon = icon
    self.message = message
    self.button = button
    self.duration = min(max(0, duration), 10)
  }
  @_disfavoredOverload
  internal init(
    icon: Image? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval? = nil
  ) {
    self.icon = icon
    self.message = message
    self.button = button
    self.duration = duration
  }
}

public struct ToastButton {
  public var title: String
  public var color: Color
  public var action: () -> Void
  public init(
    title: String,
    color: Color = .primary,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.color = color
    self.action = action
  }
}
