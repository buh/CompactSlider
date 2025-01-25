// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum HandleType: Equatable {
    case rectangle, roundedRectangle, circle
}

public enum HandleProgressAlignment: Equatable {
    case inside, center, outside
}

/// A handle style.
public struct HandleStyle: Equatable {
    public let type: HandleType
    public let visibility: Visibility
    public let progressAlignment: HandleProgressAlignment
    public let color: Color
    public let width: CGFloat
    public let lineWidth: CGFloat
    public let cornerRadius: CGFloat
    
    init(
        type: HandleType,
        visibility: Visibility,
        progressAlignment: HandleProgressAlignment,
        color: Color,
        width: CGFloat,
        lineWidth: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.type = type
        self.visibility = visibility
        self.progressAlignment = progressAlignment
        self.color = color
        self.width = width
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
}

extension HandleStyle {
    public static func rectangle(
        visibility: Visibility = .handleDefault,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        lineWidth: CGFloat = Defaults.handleLineWidth
    ) -> HandleStyle {
        .init(
            type: .rectangle,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            lineWidth: lineWidth,
            cornerRadius: 0
        )
    }
    
    public static func roundedRectangle(
        visibility: Visibility = .handleDefault,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        lineWidth: CGFloat = Defaults.handleLineWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius
    ) -> HandleStyle {
        .init(
            type: .roundedRectangle,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius
        )
    }
    
    public static func circle(
        visibility: Visibility = .handleDefault,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        radius: CGFloat = Defaults.circleHandleRadius,
        lineWidth: CGFloat = 0
    ) -> HandleStyle {
        .init(
            type: .circle,
            visibility: visibility,
            progressAlignment: progressAlignment,
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

extension View {
    public func compactSliderHandleStyle(_ style: HandleStyle) -> some View {
        environment(\.handleStyle, style)
    }
}
