// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A handle type. It could be a rectangle, rounded rectangle, circle, capsule, or a symbol.
public enum HandleType: Equatable {
    case rectangle
    case roundedRectangle
    case circle
    case capsule
    case symbol(String)
    case `default`
}

/// A handle alignment with the progress view. It could be inside, center, or outside.
///
/// - inside: The handle is inside the progress view.
/// - center: The handle is in the center of the edge of the progress view.
/// - outside: The handle is outside the progress view.
public enum HandleProgressAlignment: Equatable {
    case inside, center, outside
}

/// A handle style.
public struct HandleStyle: Equatable {
    /// The handle type.
    public let type: HandleType
    /// The visibility of the handle. It could be always visible, hidden, or visible on focus (on drag or hover).
    public let visibility: CompactSliderVisibility
    /// The alignment of the handle with the progress view.
    public let progressAlignment: HandleProgressAlignment
    /// The color of the handle.
    public let color: Color
    /// The width of the handle.
    public let width: CGFloat
    /// The corner radius of the handle.
    public let cornerRadius: CGFloat
    /// The stroke style of the handle. If it's nil the handle will be filled.
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
    /// Creates a rectangle handle style.
    ///
    /// - Parameters:
    ///   - visibility: a visibility of the handle.
    ///   - progressAlignment: a handle alignment with the progress view.
    ///   - color: a handle color.
    ///   - width: a handle width. It's used to calculate the position of the handle and progress view.
    ///   - strokeStyle: a handle stroke style. If it's nil the handle will be filled.
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
    
    /// Creates a rounded rectangle handle style.
    ///
    /// - Parameters:
    ///   - visibility: a visibility of the handle.
    ///   - progressAlignment: a handle alignment with the progress view.
    ///   - color: a handle color.
    ///   - width: a handle width. It's used to calculate the position of the handle and progress view.
    ///   - cornerRadius: a handle corner radius.
    ///   - strokeStyle: a handle stroke style. If it's nil the handle will be filled.
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
    
    /// Creates a circle handle style.
    ///
    /// - Parameters:
    ///   - visibility: a visibility of the handle.
    ///   - progressAlignment: a handle alignment with the progress view.
    ///   - color: a handle color.
    ///   - radius: a handle radius. It's used to calculate the position of the handle and progress view.
    ///   - strokeStyle: a handle stroke style. If it's nil the handle will be filled.
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
    
    /// Creates a capsule handle style.
    ///
    /// - Parameters:
    ///   - visibility: a visibility of the handle.
    ///   - progressAlignment: a handle alignment with the progress view.
    ///   - color: a handle color.
    ///   - width: a handle width. It's used to calculate the position of the handle and progress view.
    ///   - strokeStyle: a handle stroke style. If it's nil the handle will be filled.
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
    
    /// Creates a symbol handle style. The symbol is a system image. For example, "circle.fill".
    ///
    /// - Parameters:
    ///   - name: a system image name.
    ///   - visibility: a visibility of the handle.
    ///   - progressAlignment: a handle alignment with the progress view.
    ///   - color: a handle color.
    ///   - width: a handle width. It's used to calculate the position of the handle and progress view.
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
