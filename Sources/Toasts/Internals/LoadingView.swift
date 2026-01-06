import SwiftUI

internal struct LoadingView: View {
  @State private var toggle = false
  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.primary.opacity(0.2), lineWidth: 2)

      Circle()
        .trim(from: 0.0, to: 0.3)
        .stroke(Color.primary, lineWidth: 2)
        .rotationEffect(.degrees(toggle ? 360 : 0))
    }
    .frame(width: 16, height: 16)
    .onAppear {
      withAnimation(.linear.repeatForever(autoreverses: false).speed(0.3)) {
        toggle = true
      }
    }
  }
}

#Preview {
  LoadingView()
}
