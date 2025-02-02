//
//  File.swift
//  CompactSlider
//
//  Created by Aleksei Bukhtin on 04/01/2025.
//

import Foundation
#if canImport(WatchKit)
import WatchKit
#endif
#if canImport(UIKit)
    import UIKit
#endif

enum ScreenInfo {
    #if os(watchOS)
    static let scale = WKInterfaceDevice.current().screenScale
    #else
        #if canImport(UIKit) && !os(visionOS)
        static let scale = UIScreen.main.scale
        #else
        static let scale: Double = 2
        #endif
    #endif
}

extension CGFloat {
    func pixelPerfect() -> Self {
        (self * ScreenInfo.scale).rounded(.towardZero) / ScreenInfo.scale
    }
}
