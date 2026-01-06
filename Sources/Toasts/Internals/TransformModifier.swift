import SwiftUI

internal struct TransformModifier: ViewModifier {
  var yOffset: CGFloat
  var scale: CGFloat
  var opacity: Double

  func body(content: Content) -> some View {
    content
      .opacity(opacity)
      .scaleEffect(scale)
      .offset(y: yOffset)
  }
}
