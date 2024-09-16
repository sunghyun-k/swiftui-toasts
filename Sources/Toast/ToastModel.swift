import Foundation

import struct SwiftUI.Image
import struct SwiftUI.Color

public struct ToastModel: Identifiable, Equatable {
  public let id = UUID()
  internal var icon: Image?
  internal var message: String
  internal var button: ToastButton?
  public init(
    icon: Image? = nil,
    message: String,
    button: ToastButton? = nil
  ) {
    self.icon = icon
    self.message = message
    self.button = button
  }

  public static func ==(lhs: ToastModel, rhs: ToastModel) -> Bool {
    return lhs.id == rhs.id
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
