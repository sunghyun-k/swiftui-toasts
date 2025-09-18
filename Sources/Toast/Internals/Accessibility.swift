import UIKit

@MainActor
func announceToAccessibility(_ message: String) {
  guard !message.isEmpty, UIAccessibility.isVoiceOverRunning else { return }

  let attributedMessage = createAttributedAccessibilityMessage(message)
  UIAccessibility.post(notification: .announcement, argument: attributedMessage)
}

private func createAttributedAccessibilityMessage(_ message: String) -> NSAttributedString {
  var attributes: [NSAttributedString.Key: Any] = [
    .accessibilitySpeechQueueAnnouncement: false
  ]
  if #available(iOS 17.0, *) {
    attributes[.accessibilitySpeechAnnouncementPriority] = UIAccessibilityPriority.high.rawValue
  }
  return NSAttributedString(string: message, attributes: attributes)
}
