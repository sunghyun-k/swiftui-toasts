import SwiftUI
import Toasts

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
            message: "typed message: \(message)"
          )
          presentToast(toast)
        }
      }
    }
    .addToastSafeAreaObserver()
    .toolbarVisibility(showTab ? .visible : .hidden, for: .tabBar)
  }
}
