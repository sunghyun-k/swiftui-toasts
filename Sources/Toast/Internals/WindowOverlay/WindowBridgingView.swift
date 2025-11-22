import SwiftUI
import UIKit

internal struct WindowBridgingView<V: View>: UIViewRepresentable {
  var isPresented: Bool
  var disableSafeArea: Bool
  var content: V

  func makeUIView(context: Context) -> _HelperView {
    return _HelperView(
      isPresented: isPresented,
      disableSafeArea: disableSafeArea,
      content: EnvPassingView(
        content: content,
        environment: context.environment
      )
    )
  }
  func updateUIView(_ helper: _HelperView, context: Context) {
    helper.setContent(
      isPresented: isPresented,
      disableSafeArea: disableSafeArea,
      content: EnvPassingView(
        content: content,
        environment: context.environment
      )
    )
  }

  fileprivate struct EnvPassingView: View {
    var content: V
    var environment: EnvironmentValues

    var body: some View {
      content.environment(\.self, environment)
    }
  }

  internal final class _HelperView: UIView {
    private var isPresented: Bool
    private var disableSafeArea: Bool
    private var content: EnvPassingView

    private var overlayWindow: WindowOverlayWindow?
    private var hostingController: UIHostingController<EnvPassingView>? {
      overlayWindow?.rootViewController as? UIHostingController<EnvPassingView>
    }

    fileprivate init(isPresented: Bool, disableSafeArea: Bool, content: EnvPassingView) {
      self.isPresented = isPresented
      self.disableSafeArea = disableSafeArea
      self.content = content
      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func willMove(toWindow newWindow: UIWindow?) {
      super.willMove(toWindow: newWindow)
      if let windowScene = newWindow?.windowScene {
        overlayWindow = WindowOverlayWindow(windowScene: windowScene)
        updateView()
      }
    }

    fileprivate func setContent(
      isPresented: Bool,
      disableSafeArea: Bool,
      content: EnvPassingView
    ) {
      self.isPresented = isPresented
      self.disableSafeArea = disableSafeArea
      self.content = content
      updateView()
    }

    private func updateView() {
      if isPresented {
        if hostingController == nil {
          overlayWindow?.rootViewController = UIHostingController(rootView: content)
          overlayWindow?.rootViewController?.view.backgroundColor = .clear
          hostingController?.disableSafeArea(disableSafeArea)
        } else {
          hostingController?.rootView = content
        }
        overlayWindow?.isHidden = false
      } else {
        overlayWindow?.rootViewController = nil
        overlayWindow?.isHidden = true
      }
    }
  }
}

extension UIHostingController {
  func disableSafeArea(_ disable: Bool) {
    if #available(iOS 16.4, *) {
      self.safeAreaRegions = disable ? [] : .all
    } else {
      self._disableSafeArea = disable
    }
  }
}

