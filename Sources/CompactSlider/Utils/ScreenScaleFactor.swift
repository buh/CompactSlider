//
//  File.swift
//  CompactSlider
//
//  Created by Aleksei Bukhtin on 04/01/2025.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#endif

enum ScreenInfo {
    #if canImport(UIKit)
    static let scale = UIScreen.main.scale
    #else
    static let scale: Double = 2
    #endif
}

extension CGFloat {
    func roundedByPixel() -> Self {
        (self * ScreenInfo.scale).rounded(.towardZero) / ScreenInfo.scale
    }
}
