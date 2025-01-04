// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public enum Defaults {}

// MARK: - CGFloat

public extension Defaults {
    static let cornerRadius: CGFloat = {
        #if os(macOS)
        4
        #else
        8
        #endif
    }()
    
    // MARK: - Handle
    
    static let handleWidth: CGFloat = {
        #if os(macOS)
        3
        #else
        16
        #endif
    }()
    
    static let handleCornerRadius: CGFloat = {
        #if os(macOS)
        0
        #else
        8
        #endif
    }()
    
    // MARK: - Scale
    
    static let scaleLineThickness: CGFloat = 1
    
    static let scaleLineLength: CGFloat = {
        #if os(macOS)
        5
        #else
        10
        #endif
    }()
    
    static let secondaryScaleLineLength: CGFloat = {
        #if os(macOS)
        3
        #else
        6
        #endif
    }()
}

// MARK: - Colors

public extension Defaults {
    #if os(macOS)
    static let label = Color(NSColor.labelColor)
    #elseif os(watchOS)
    static let label = Color.white
    #else
    static let label = Color(UIColor.label)
    #endif
    
    static let backgroundOpacity: Double = 0.075
    static let progressOpacity: Double = 0.1
    static let focusedProgressOpacity: Double = 0.125
    static let scaleLineOpacity: Double = 0.5
    static let secondaryScaleLineOpacity: Double = 0.25
    
    static let backgroundColor: Color = label.opacity(Self.backgroundOpacity)
    static let progressColor: Color = label.opacity(Self.progressOpacity)
    static let focusedProgressColor: Color = label.opacity(Self.focusedProgressOpacity)
    static let scaleLineColor: Color = label.opacity(Self.scaleLineOpacity)
    static let secondaryScaleLineColor: Color = label.opacity(Self.secondaryScaleLineOpacity)
}
