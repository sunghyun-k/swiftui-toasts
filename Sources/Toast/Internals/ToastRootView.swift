import SwiftUI

internal struct ToastRootView: View {

  @ObservedObject var manager: ToastManager

  var body: some View {
    main
      .onAppear(perform: manager.onAppear)
  }

  @ViewBuilder
  private var main: some View {
    let isTop = manager.position == .top
    VStack(spacing: 8) {
      if !isTop { Spacer() }

      let models = isTop ? manager.models.reversed() : manager.models
      ForEach(manager.isAppeared ? models : []) { model in
        ToastInteractingView(model: model, manager: manager)
          .transition(
            .modifier(
              active: TransformModifier(
                yOffset: isTop ? -96 : 96,
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

      if isTop { Spacer() }
    }
    .animation(
      .spring(duration: removalAnimationDuration),
      value: Tuple(count: manager.models.count, isAppeared: manager.isAppeared)
    )
    .padding()
    .padding(manager.safeAreaInsets)
    .animation(.spring(duration: removalAnimationDuration), value: manager.safeAreaInsets)
    .ignoresSafeArea()
  }
}

private struct Tuple: Equatable {
  var count: Int
  var isAppeared: Bool
}
