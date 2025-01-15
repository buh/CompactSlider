// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum HandleType: Equatable {
    case rectangle, roundedRectangle, circle
}

/// A handle style.
public struct HandleStyle: Equatable {
    let type: HandleType
    let visibility: Visibility
    let color: Color
    let width: CGFloat
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    init(
        type: HandleType,
        visibility: Visibility,
        color: Color,
        width: CGFloat,
        lineWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.type = type
        self.visibility = visibility
        self.color = color
        self.width = width
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
}

extension HandleStyle {
    public static func rectangle(
        visibility: Visibility = .handleDefault,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        lineWidth: CGFloat = Defaults.handleLineWidth
    ) -> HandleStyle {
        .init(
            type: .rectangle,
            visibility: visibility,
            color: color,
            width: width,
            lineWidth: lineWidth,
            cornerRadius: 0
        )
    }
    
    public static func roundedRectangle(
        visibility: Visibility = .handleDefault,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        lineWidth: CGFloat = Defaults.handleLineWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius
    ) -> HandleStyle {
        .init(
            type: .roundedRectangle,
            visibility: visibility,
            color: color,
            width: width,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius
        )
    }
    
    public static func circle(
        visibility: Visibility = .handleDefault,
        color: Color = .accentColor,
        radius: CGFloat = Defaults.circleHandleRadius,
        lineWidth: CGFloat = 0
    ) -> HandleStyle {
        .init(
            type: .circle,
            visibility: visibility,
            color: color,
            width: 2 * radius,
            lineWidth: lineWidth,
            cornerRadius: 0
        )
    }
}

// MARK: - Environment

struct HandleStyleKey: EnvironmentKey {
    static var defaultValue: HandleStyle = .rectangle()
}

extension EnvironmentValues {
    var handleStyle: HandleStyle {
        get { self[HandleStyleKey.self] }
        set { self[HandleStyleKey.self] = newValue }
    }
}
