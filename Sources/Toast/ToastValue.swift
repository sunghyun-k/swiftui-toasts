import Foundation
import SwiftUI

/// Represents a toast notification with customizable content and behavior.
public struct ToastValue {
  internal var icon: AnyView?
  internal var message: String
  internal var textColor: Color?
  internal var backgroundColor: Color?
  internal var button: ToastButton?
  /// If nil, the toast will persist and not disappear. Used when displaying a loading toast.
  internal var duration: TimeInterval?

  /// Creates a new toast with the specified content and behavior.
  ///
  /// - Parameters:
  ///   - icon: An optional view to display as an icon in the toast.
  ///   - message: The text content of the toast.
  ///   - button: An optional action button to display in the toast.
  ///   - duration: How long the toast should be displayed before automatically dismissing, in seconds. Clamped between 0 and 10 seconds. Default is 3.0.
  public init(
    icon: (any View)? = nil,
    message: String,
    textColor: Color? = nil,
    backgroundColor: Color? = nil,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.button = button
    self.duration = min(max(0, duration), 10)
  }
  @_disfavoredOverload
  internal init(
    icon: (any View)? = nil,
    message: String,
    textColor: Color? = nil,
    backgroundColor: Color? = nil,
    button: ToastButton? = nil,
    duration: TimeInterval? = nil
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.backgroundColor = backgroundColor
    self.button = button
    self.duration = duration
  }
}

/// Represents an action button that can be displayed within a toast.
public struct ToastButton {
  /// The text to display on the button.
  public var title: String

  /// The color of the button text.
  public var color: Color

  /// The action to perform when the button is tapped.
  public var action: () -> Void

  /// Creates a new toast button with the specified title, color, and action.
  ///
  /// - Parameters:
  ///   - title: The text to display on the button.
  ///   - color: The color of the button text. Default is `.primary`.
  ///   - action: The closure to execute when the button is tapped.
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
