#if os(iOS)
import UIKit
#endif
import SwiftUI

@MainActor
func announceToAccessibility(_ message: String) {
  #if os(iOS)
  guard !message.isEmpty, UIAccessibility.isVoiceOverRunning else { return }

  let attributedMessage = createAttributedAccessibilityMessage(message)
  UIAccessibility.post(notification: .announcement, argument: attributedMessage)
  #endif
}

#if os(iOS)
private func createAttributedAccessibilityMessage(_ message: String) -> NSAttributedString {
  var attributes: [NSAttributedString.Key: Any] = [
    .accessibilitySpeechQueueAnnouncement: false
  ]
  if #available(iOS 17.0, *) {
    attributes[.accessibilitySpeechAnnouncementPriority] = UIAccessibilityPriority.high.rawValue
  }
  return NSAttributedString(string: message, attributes: attributes)
}
#endif
