import SwiftUI

@testable import Toasts

struct ContentView: View {
  @Environment(\.presentToast) var presentToast
  @State private var message = ""
  @State private var showTab = true
  var body: some View {
    TabView {
      Tab("Tab 1", systemImage: "square.and.arrow.up") {
        tab1
      }
      Tab("Tab 2", systemImage: "square.and.arrow.down") {
        Text("This is tab 2.")
      }
    }
  }

  private var tab1: some View {
    ScrollView {
      VStack(alignment: .leading) {
        TextField("Enter your message", text: $message)
        Toggle("Show Tab", isOn: $showTab)

        Button("Show Toast") {
          let toast = ToastValue(
            icon: Image(systemName: "bell"),
            message: "typed message: \(message)",
            haptic: .info
          )
          presentToast(toast)
        }

        Button("Show Success Toast") {
          let toast = ToastValue(
            icon: Image(systemName: "checkmark.circle"),
            message: "Success!",
            haptic: .success
          )
          presentToast(toast)
        }

        Button("Show Error Toast") {
          let toast = ToastValue(
            icon: Image(systemName: "xmark.circle"),
            message: "Error occurred",
            haptic: .error
          )
          presentToast(toast)
        }

        Button("Show Warning Toast") {
          let toast = ToastValue(
            icon: Image(systemName: "exclamationmark.triangle"),
            message: "Warning!",
            haptic: .warning
          )
          presentToast(toast)
        }

        Button("Show Loading Toast") {
          Task {
            try await presentToast(
              message: "Loading...",
              task: {
                await loadSucceess()
              },
              onSuccess: { result in
                ToastValue(icon: Image(systemName: "checkmark.circle"), message: result, haptic: .success)
              },
              onFailure: { error in
                ToastValue(
                  icon: Image(systemName: "xmark.circle"), message: error.localizedDescription, haptic: .error)
              })
          }
        }

        Button("Show Loading Toast with Failure") {
          Task {
            try await presentToast(
              message: "Loading...",
              task: {
                try await loadFailure()
              },
              onSuccess: { result in
                ToastValue(icon: Image(systemName: "checkmark.circle"), message: result, haptic: .success)
              },
              onFailure: { error in
                ToastValue(
                  icon: Image(systemName: "xmark.circle"), message: error.localizedDescription, haptic: .error)
              })
          }
        }
      }
    }
    .addToastSafeAreaObserver()
    .toolbarVisibility(showTab ? .visible : .hidden, for: .tabBar)
  }

  private func loadSucceess() async -> String {
    try? await Task.sleep(seconds: 1)
    return "Success"
  }

  private func loadFailure() async throws -> String {
    try await Task.sleep(seconds: 1)
    throw NSError(domain: "Error", code: 1)
  }
}
