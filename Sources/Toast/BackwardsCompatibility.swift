//
//  BackwardsCompatibility.swift
//  swiftui-toasts
//
//  Created by Yasin Onur on 21.08.2025.
//

import Foundation
import SwiftUI

public extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
