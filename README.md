# Toasts

A toast notification library for SwiftUI.

## Features

- Easy-to-use toast notifications
- Support for custom icons, messages, and buttons
- Seamless integration with SwiftUI
- Dark mode support

## Usage

1. Install toast in your view:

```swift
import SwiftUI
import Toasts

@main
struct ToastAppApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .installToast()
    }
  }
}
```

2. Present a toast:

```swift
@Environment(\.presentToast) var presentToast

Button("Show Toast") {
  let toast = ToastModel(
    icon: Image(systemName: "bell"),
    message: "You have a new notification."
  )
  presentToast(toast)
}
```


## Customization

- **Remove icon**

  ```swift
  let toast = ToastModel(
    message: "Message only toast."
  )
  ```


- **Add button**

  ```swift
  let toast = ToastModel(
    message: "Toast with action required.",
    button: ToastButton(title: "Confirm", action: {
      // Handle button action
    })
  )
  ```


## Requirements

- iOS 14.0+
- Swift 5.9+
