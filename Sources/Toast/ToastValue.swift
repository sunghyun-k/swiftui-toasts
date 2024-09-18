import Foundation
import SwiftUI

public struct ToastValue {
  internal var icon: AnyView?
  internal var message: String
  internal var button: ToastButton?
  /// If nil, the toast will persist and not disappear. Used when displaying a loading toast.
  internal var duration: TimeInterval?
  public init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.button = button
    self.duration = min(max(0, duration), 10)
  }
  @_disfavoredOverload
  internal init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval? = nil
  ) {
    self.icon = icon.map { AnyView($0) }
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
