import SwiftUI

internal struct ToastInteractingView: View {

  var model: ToastModel
  let manager: ToastManager
  @GestureState private var yOffset: CGFloat?
  @State private var dismissTask: Task<Void, any Error>?

  private var isDragging: Bool { yOffset != nil }

  var body: some View {
    main
      .onChange(of: isDragging) { newValue in
        if newValue {
          dismissTask?.cancel()
          dismissTask = nil
        }
      }
      .onAppear {
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
        state = value.translation.height
      }
      .onEnded { value in
        if value.translation.height > 48/2 {
          manager.remove(model)
        } else {
          startDismissTask()
        }
      }
  }

  private func startDismissTask() {
    dismissTask?.cancel()
    dismissTask = Task {
      try await manager.startRemovalTask(for: model)
    }
  }
}
