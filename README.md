# Toasts

A toast notification library for SwiftUI.

- Fork:
Added custom text, background and button coloring.
Added iOS 26 Glass Effect to toast views.

![Simulator Screen Recording - iPhone 15 Pro - 2024-09-16 at 11 53 37](https://github.com/user-attachments/assets/7b11b2f1-ed6e-4955-a674-c3bfd49ab8ad)

![Simulator Screen Recording - iPhone 16 Pro - 2024-09-18 at 10 53 57](https://github.com/user-attachments/assets/6c5f4906-aab6-4ef6-b9bb-844d7110586b)

<img width="341" alt="SCR-20240916-kqog" src="https://github.com/user-attachments/assets/c072c767-8e26-471b-b156-80b204ca433b">

## Features

- Easy-to-use toast notifications
- Support for custom icons, messages, and buttons
- Seamless integration with SwiftUI
- Dark mode support
- Slide gesture to dismiss
- Loading state interface with async/await

## Usage

1. Install toast in your root view:

```swift
import SwiftUI
import Toasts

@main
struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .installToast(position: .bottom)
    }
  }
}
```

2. Present a toast:

```swift
@Environment(\.presentToast) var presentToast

Button("Show Toast") {
  let toast = ToastValue(
    icon: Image(systemName: "bell"),
    message: "You have a new notification."
  )
  presentToast(toast)
}
```

## Advanced Usage

```swift
presentToast(
  message: "Loading...",
  task: {
    // Handle loading task
    return "Success"
  },
  onSuccess: { result in
    ToastValue(icon: Image(systemName: "checkmark.circle"), message: result)
  },
  onFailure: { error in
    ToastValue(icon: Image(systemName: "xmark.circle"), message: error.localizedDescription)
  }
)
```

## Customization

<img width="356" alt="image" src="https://github.com/user-attachments/assets/937ef007-cbe7-4462-963c-2fb92a6cd844">

- **Remove icon**

```swift
let toast = ToastValue(
  message: "Message only toast."
)
```

- **Add button**

```swift
let toast = ToastValue(
  message: "Toast with action required.",
  button: ToastButton(title: "Confirm", color: .green, action: {
    // Handle button action
  })
)
```

## Custom SafeArea Handling

If you need to manually control the safe area insets for toasts (e.g., in a custom view hierarchy or when using multiple tabs), you can use the `addToastSafeAreaObserver` modifier:

```swift
struct ContentView: View {
  var body: some View {
    TabView {
      Tab1View()
      Tab2View()
    }
  }
}

struct Tab1View: View {
  var body: some View {
    ScrollView {
      // Your content here
    }
    .addToastSafeAreaObserver()
  }
}
```

This modifier helps the toast system correctly detect and respond to safe area changes, which is particularly useful in complex view hierarchies or when using TabView.

## Requirements

- iOS 14.0+
- Swift 5.9+
