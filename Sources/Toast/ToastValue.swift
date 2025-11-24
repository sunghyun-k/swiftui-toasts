import Foundation
import SwiftUI

/// The haptic feedback type for a toast notification.
public enum ToastHaptic {
  case success
  case error
  case warning
  case info
  
  #if os(iOS)
  @available(iOS 13.0, *)
  internal var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
    switch self {
    case .success:
      return .success
    case .error:
      return .error
    case .warning:
      return .warning
    case .info:
      return .success
    }
  }
  #endif
}

/// Represents a toast notification with customizable content and behavior.
public struct ToastValue {
  internal var icon: AnyView?
  internal var message: String
  internal var button: ToastButton?
  /// If nil, the toast will persist and not disappear. Used when displaying a loading toast.
  internal var duration: TimeInterval?
  /// The haptic feedback type for this toast.
  internal var haptic: ToastHaptic?

  /// Creates a new toast with the specified content and behavior.
  ///
  /// - Parameters:
  ///   - icon: An optional view to display as an icon in the toast.
  ///   - message: The text content of the toast.
  ///   - button: An optional action button to display in the toast.
  ///   - duration: How long the toast should be displayed before automatically dismissing, in seconds. Clamped between 0 and 10 seconds. Default is 3.0.
  ///   - haptic: The haptic feedback type for this toast. Default is `.info`.
  public init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0,
    haptic: ToastHaptic? = .info
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.button = button
    self.duration = min(max(0, duration), 10)
    self.haptic = haptic
  }

  /// Convenience initializer that uses a system image name for the icon.
  ///
  /// - Parameters:
  ///   - systemImage: The name of the system image to use as an icon.
  ///   - message: The text content of the toast.
  ///   - button: An optional action button to display in the toast.
  ///   - duration: How long the toast should be displayed before automatically dismissing, in seconds. Clamped between 0 and 10 seconds. Default is 3.0.
  ///   - haptic: The haptic feedback type for this toast. Default is `.info`.
  public init(
    systemImage: String,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0,
    haptic: ToastHaptic? = .info
  ) {
    self.init(
      icon: Image(systemName: systemImage),
      message: message,
      button: button,
      duration: duration,
      haptic: haptic
    )
  }

  /// Convenience initializer that uses a named image asset for the icon.
  ///
  /// - Parameters:
  ///   - image: The name of the image asset to use as an icon.
  ///   - message: The text content of the toast.
  ///   - button: An optional action button to display in the toast.
  ///   - duration: How long the toast should be displayed before automatically dismissing, in seconds. Clamped between 0 and 10 seconds. Default is 3.0.
  ///   - haptic: The haptic feedback type for this toast. Default is `.info`.
  public init(
    image: String,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval = 3.0,
    haptic: ToastHaptic? = .info
  ) {
    self.init(
      icon: Image(image),
      message: message,
      button: button,
      duration: duration,
      haptic: haptic
    )
  }

  @_disfavoredOverload
  internal init(
    icon: (any View)? = nil,
    message: String,
    button: ToastButton? = nil,
    duration: TimeInterval? = nil,
    haptic: ToastHaptic? = nil
  ) {
    self.icon = icon.map { AnyView($0) }
    self.message = message
    self.button = button
    self.duration = duration
    self.haptic = haptic
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
