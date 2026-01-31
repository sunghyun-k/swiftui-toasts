import SwiftUI

internal struct ToastInteractingView: View {

  @ObservedObject var model: ToastModel
  let manager: ToastManager
  @GestureState private var yOffset: CGFloat?
  @State private var dismissTask: Task<Void, any Error>?

  private var isDragging: Bool { yOffset != nil }

  var body: some View {
    main
      ._onChange(of: isDragging) { _, newValue in
        if newValue {
          dismissTask?.cancel()
          dismissTask = nil
        }
      }
      ._onChange(of: model.duration == nil, initial: true) { _, newValue in
        startDismissTask()
      }
  }

  @MainActor
  private var main: some View {
    ToastView(model: model)
      .offset(y: yOffset ?? 0)
      .gesture(dragGesture)
      .animation(.spring, value: isDragging)
  }

  @MainActor
  private var dragGesture: some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($yOffset) { value, state, _ in
        let translation = value.translation.height
        if model.duration == nil {
          state = translation * 0.5
        } else {
          let isTopPosition = manager.position == .top
          let shouldReduceTranslation = (isTopPosition && translation > 0) || (!isTopPosition && translation < 0)
          state = shouldReduceTranslation ? translation * 0.5 : translation
        }
      }
      .onEnded { value in
        if model.duration == nil { return }
        let threshold: CGFloat = 48 / 2
        let draggedAmount = manager.position == .top ? -value.translation.height : value.translation.height
        if draggedAmount > threshold {
          manager.remove(model)
        } else {
          startDismissTask()
        }
      }
  }

  private func startDismissTask() {
    dismissTask?.cancel()
    dismissTask = Task {
      await manager.startRemovalTask(for: model)
    }
  }
}
