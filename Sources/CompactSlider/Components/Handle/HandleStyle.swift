// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum HandleType: Equatable {
    case rectangle
    case roundedRectangle
    case circle
    case capsule
    case symbol(String)
    case `default`
}

public enum HandleProgressAlignment: Equatable {
    case inside, center, outside
}

/// A handle style.
public struct HandleStyle: Equatable {
    public let type: HandleType
    public let visibility: CompactSliderVisibility
    public let progressAlignment: HandleProgressAlignment
    public let color: Color
    public let width: CGFloat
    public let cornerRadius: CGFloat
    public let strokeStyle: StrokeStyle?
    
    init(
        type: HandleType,
        visibility: CompactSliderVisibility,
        progressAlignment: HandleProgressAlignment,
        color: Color,
        width: CGFloat,
        cornerRadius: CGFloat,
        strokeStyle: StrokeStyle?
    ) {
        self.type = type
        self.visibility = visibility
        self.progressAlignment = progressAlignment
        self.color = color
        self.width = width
        self.strokeStyle = strokeStyle
        self.cornerRadius = cornerRadius
    }
}

// MARK: - Constructors

extension HandleStyle {
    public static func rectangle(
        visibility: CompactSliderVisibility = .default,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        strokeStyle: StrokeStyle? = nil
    ) -> HandleStyle {
        .init(
            type: .rectangle,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            cornerRadius: 0,
            strokeStyle: strokeStyle
        )
    }
    
    public static func roundedRectangle(
        visibility: CompactSliderVisibility = .default,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius,
        strokeStyle: StrokeStyle? = nil
    ) -> HandleStyle {
        .init(
            type: .roundedRectangle,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            cornerRadius: cornerRadius,
            strokeStyle: strokeStyle
        )
    }
    
    public static func circle(
        visibility: CompactSliderVisibility = .default,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        radius: CGFloat = Defaults.circleHandleRadius,
        strokeStyle: StrokeStyle? = nil
    ) -> HandleStyle {
        .init(
            type: .circle,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: 2 * radius,
            cornerRadius: 0,
            strokeStyle: strokeStyle
        )
    }
    
    public static func capsule(
        visibility: CompactSliderVisibility = .default,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        strokeStyle: StrokeStyle? = nil
    ) -> HandleStyle {
        .init(
            type: .capsule,
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            cornerRadius: 0,
            strokeStyle: strokeStyle
        )
    }
    
    public static func symbol(
        _ name: String,
        visibility: CompactSliderVisibility = .default,
        progressAlignment: HandleProgressAlignment = .center,
        color: Color = .accentColor,
        width: CGFloat = 20
    ) -> HandleStyle {
        .init(
            type: .symbol(name),
            visibility: visibility,
            progressAlignment: progressAlignment,
            color: color,
            width: width,
            cornerRadius: 0,
            strokeStyle: nil
        )
    }
    
    static func `default`() -> HandleStyle {
        HandleStyle(
            type: .default,
            visibility: .default,
            progressAlignment: .center,
            color: .accentColor,
            width: 0,
            cornerRadius: 0,
            strokeStyle: nil
        )
    }
}
