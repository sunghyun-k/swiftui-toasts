import SwiftUI

internal struct ToastRootView: View {

  @ObservedObject var manager: ToastManager

  var body: some View {
    main
      .onAppear(perform: manager.onAppear)
  }

  private var main: some View {
    VStack(spacing: 8) {
      Spacer()
      ForEach(manager.isAppeared ? manager.toasts : []) { toast in
        ToastInteractingView(model: toast, manager: manager)
          .transition(
            .modifier(
              active: TransformModifier(
                yOffset: 48 * 2,
                scale: 0.5,
                opacity: 0.0
              ),
              identity: TransformModifier(
                yOffset: 0,
                scale: 1.0,
                opacity: 1.0
              )
            )
          )
      }
    }
    .animation(
      .spring(duration: removalAnimationDuration),
      value: Tuple(count: manager.toasts.count, isAppeared: manager.isAppeared)
    )
  }
}

private struct Tuple: Equatable {
  var count: Int
  var isAppeared: Bool
}
