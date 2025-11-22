import SwiftUI

internal struct ToastView: View {
  @ObservedObject var model: ToastModel
  @Environment(\.colorScheme) private var colorScheme

  private var isDark: Bool { colorScheme == .dark }

  var body: some View {
    if #available(iOS 26.0, *) {
      // iOS 26+ — let the system draw Liquid Glass
      main
        .glassEffect(.regular.interactive(true))
        .frame(height: 48)
        .compositingGroup()
        .shadow(
          color: .primary.opacity(isDark ? 0.0 : 0.1),
          radius: 16,
          y: 8
        )
    } else {
      // Older iOS — your old capsule background
      main
        .padding(.horizontal, 12)
        .background(
          Capsule()
            .fill(Color.toastBackground)
        )
        .frame(height: 48)
        .compositingGroup()
        .shadow(
          color: .primary.opacity(isDark ? 0.0 : 0.1),
          radius: 16,
          y: 8
        )
    }
  }

  private var main: some View {
    HStack(spacing: 10) {
      if let icon = model.icon {
        icon
          .frame(width: 19, height: 19)
          .padding(.leading, 15)
      } else {
        Color.clear
          .frame(width: 14)
      }
      Text(model.message)
        .lineLimit(1)
        .truncationMode(.tail)
        .id(model.message)
        .transition(.asymmetric(
            insertion: .opacity
                .animation(.spring(duration: 0.3).delay(0.3)),
            removal: .opacity
                .animation(.spring(duration: 0.3))
        ))
      if let button = model.button {
        buttonView(button)
          .padding([.top, .bottom, .trailing], 10)
      } else {
        Color.clear
          .frame(width: 14)
      }
    }
    .font(.system(size: 16, weight: .medium))
  }

  private func buttonView(_ button: ToastButton) -> some View {
    Button {
      button.action()
    } label: {
      ZStack {
        Capsule()
          .fill(button.color.opacity(isDark ? 0.15 : 0.07))
        Text(button.title)
          ._foregroundColor(button.color)
          .padding(.horizontal, 9)
      }
      .frame(minWidth: 64)
      .fixedSize(horizontal: true, vertical: false)
    }
    .buttonStyle(.plain)
  }
}

@available(iOS 17.0, *)
#Preview {
  let group = VStack {
    ToastView(
      model: .init(
        value:
          .init(
            icon: Image(systemName: "info.circle"),
            message: "This is a toast message",
            button: .init(title: "Action", color: .red, action: {})
          )
      )
    )
    ToastView(
      model: .init(
        value:
          .init(
            icon: Image(systemName: "info.circle"),
            message: "This is a toast message",
            button: .init(title: "Action", action: {})
          )
      )
    )
    ToastView(
      model: .init(
        value:
          .init(
            icon: Image(systemName: "info.circle"),
            message: "This is a toast message",
            button: nil
          )
      )
    )
    ToastView(
      model: .init(
        value:
          .init(
            icon: nil,
            message: "This is a toast message",
            button: nil
          )
      )
    )
    ToastView(
      model: .init(
        value:
          .init(
            icon: nil,
            message: "Copied",
            button: nil
          )
      )
    )
  }
  return VStack {
    group
    group
      .padding(20)
      .background {
        Color.black
      }
      .environment(\.colorScheme, .dark)
  }
}
