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

/// Defines some default values for the components.
public enum Defaults {}

// MARK: - CGFloat

extension Defaults {
    /// The default background corner radius.
    public static let cornerRadius: CGFloat = {
        #if os(macOS)
        4
        #else
        8
        #endif
    }()
    
    /// The default background corner radius for the grid slider.
    public static let gridCornerRadius: CGFloat = 16
    /// The default padding for the grid slider.
    public static let gridPadding: EdgeInsets = .all(4)
    
    // MARK: - Handle
    
    /// The default handle width.
    public static let handleWidth: CGFloat = 3
    /// The default radius for the circle handle.
    public static let circleHandleRadius: CGFloat = 5
    /// The default handle line width.
    public static let handleLineWidth: CGFloat = 2
    /// The default corner radius for the rounded handle.
    public static let handleCornerRadius: CGFloat = {
        #if os(macOS)
        0
        #else
        8
        #endif
    }()
    
    // MARK: - Scale
    
    public static let scaleLineLength: CGFloat = {
        #if os(macOS)
        10
        #else
        16
        #endif
    }()
    
    public static let secondaryScaleLineLength: CGFloat = {
        #if os(macOS)
        5
        #else
        8
        #endif
    }()
}

// MARK: - Colors

extension Defaults {
    #if os(macOS)
    /// The default label color. Usually, it is the same as the text color.
    public static let labelColor = Color(NSColor.labelColor)
    #elseif os(watchOS)
    /// The default label color. Usually, it is the same as the text color.
    public static let labelColor = Color.white
    #else
    /// The default label color. Usually, it is the same as the text color.
    public static let labelColor = Color(UIColor.label)
    #endif
    
    /// The default background color.
    public static let backgroundColor: Color = labelColor.opacity(0.075)
    /// The default progress color.
    public static let progressColor: Color = labelColor.opacity(0.1)
    /// The default focused progress color.
    public static let focusedProgressColor: Color = labelColor.opacity(0.125)
    /// The default scale line color.
    #if os(visionOS)
    public static let scaleLineColor: Color = labelColor
    #else
    public static let scaleLineColor: Color = labelColor.opacity(0.4)
    #endif
    /// The default secondary scale line color.
    #if os(visionOS)
    public static let secondaryScaleLineColor: Color = labelColor.opacity(0.75)
    #else
    public static let secondaryScaleLineColor: Color = labelColor.opacity(0.2)
    #endif
}
