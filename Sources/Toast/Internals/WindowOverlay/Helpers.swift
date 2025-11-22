import UIKit
import SwiftUI

extension UIView {
  internal func colorOfPoint(_ point: CGPoint) -> UIColor {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

    var pixelData = [UInt8](repeating: 0, count: 4)
    let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

    context?.translateBy(x: -point.x, y: -point.y)

    self.layer.render(in: context!)

    let color = UIColor(red: CGFloat(pixelData[0]) / 255.0, green: CGFloat(pixelData[1]) / 255.0, blue: CGFloat(pixelData[2]) / 255.0, alpha: CGFloat(pixelData[3]) / 255.0)

    return color
  }
}

extension UIColor {
  internal var alpha: CGFloat {
    return self.cgColor.alpha
  }
}

