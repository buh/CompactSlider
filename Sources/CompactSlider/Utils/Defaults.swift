// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public enum Defaults {}

// MARK: - CGFloat

extension Defaults {
    public static let cornerRadius: CGFloat = {
        #if os(macOS)
        4
        #else
        8
        #endif
    }()
    
    public static let gridCornerRadius: CGFloat = 16
    public static let gridPadding: EdgeInsets = .all(4)
    
    // MARK: - Handle
    
    public static let handleWidth: CGFloat = {
        #if os(macOS)
        3
        #else
        16
        #endif
    }()
    
    public static let circleHandleRadius: CGFloat = 5
    public static let handleLineWidth: CGFloat = 2
    
    public static let handleCornerRadius: CGFloat = {
        #if os(macOS)
        0
        #else
        8
        #endif
    }()
    
    // MARK: - Scale
    
    public static let scaleLineThickness: CGFloat = 1
    
    public static let scaleLineLength: CGFloat = {
        #if os(macOS)
        5
        #else
        10
        #endif
    }()
    
    public static let secondaryScaleLineLength: CGFloat = {
        #if os(macOS)
        3
        #else
        6
        #endif
    }()
}

// MARK: - Colors

extension Defaults {
    #if os(macOS)
    public static let label = Color(NSColor.labelColor)
    #elseif os(watchOS)
    public static let label = Color.white
    #else
    public static let label = Color(UIColor.label)
    #endif
    
    public static let backgroundOpacity: Double = 0.075
    public static let progressOpacity: Double = 0.1
    public static let focusedProgressOpacity: Double = 0.125
    public static let scaleLineOpacity: Double = 0.5
    public static let secondaryScaleLineOpacity: Double = 0.25
    
    public static let backgroundColor: Color = label.opacity(Self.backgroundOpacity)
    public static let progressColor: Color = label.opacity(Self.progressOpacity)
    public static let focusedProgressColor: Color = label.opacity(Self.focusedProgressOpacity)
    public static let scaleLineColor: Color = label.opacity(Self.scaleLineOpacity)
    public static let secondaryScaleLineColor: Color = label.opacity(Self.secondaryScaleLineOpacity)
}
