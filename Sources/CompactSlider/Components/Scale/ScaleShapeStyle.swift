// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A style for drawing a scale.
public struct ScaleShapeStyle: Hashable {
    let color: Color
    let style: Style
}

extension ScaleShapeStyle {
    enum Style: Hashable {
        case linear(
            strokeStyle: StrokeStyle,
            axis: Axis,
            count: Int,
            lineLength: CGFloat,
            skip: LinearScaleShape.Skip?,
            skipFirst: Int,
            skipLast: Int,
            skipCurrentValue: Bool,
            startFromCenter: Bool
        )
        
        case circular(
            strokeStyle: StrokeStyle,
            step: Angle,
            minRadius: Double,
            maxRadius: Double
        )
        
        case labels(
            visibility: ScaleLabelsVisibility,
            axis: Axis,
            alignment: Alignment,
            offset: CGPoint,
            labels: [Double: String]
        )
    }
}

extension Alignment: Swift.Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .top: hasher.combine(10)
        case .topLeading: hasher.combine(11)
        case .topTrailing: hasher.combine(12)
        case .bottom: hasher.combine(20)
        case .bottomLeading: hasher.combine(21)
        case .bottomTrailing: hasher.combine(22)
        case .leading: hasher.combine(30)
        case .leadingFirstTextBaseline: hasher.combine(31)
        case .leadingLastTextBaseline: hasher.combine(32)
        case .trailing: hasher.combine(40)
        case .trailingFirstTextBaseline: hasher.combine(41)
        case .trailingLastTextBaseline: hasher.combine(42)
        case .center: hasher.combine(50)
        case .centerFirstTextBaseline: hasher.combine(51)
        case .centerLastTextBaseline: hasher.combine(52)
        default: break
        }
    }
}

extension StrokeStyle: Swift.Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lineWidth)
        hasher.combine(lineCap)
        hasher.combine(lineJoin)
        hasher.combine(miterLimit)
        hasher.combine(dash)
        hasher.combine(dashPhase)
    }
}

// MARK: - Constructors

extension ScaleShapeStyle {
    /// Creates a linear scale shape style.
    ///
    /// - Parameters:
    ///  - axis: an axis of the scale.
    ///  - count: a count of the scale lines.
    ///  - color: a color of the scale lines.
    ///  - strokeStyle: a stroke style of the scale lines.
    ///  - lineLength: a length of the scale lines.
    ///  - skip: a `LinearScaleShape.Skip` type for skipping each or some scale lines.
    ///  - skipFirst: a number of the first skipped scale lines.
    ///  - skipLast: a number of the last skipped scale lines.
    ///  - skipCurrentValue: a flag to skip a scale line for the current value.
    ///  - startFromCenter: a flag to start drawing scale lines from the center.
    public static func linear(
        axis: Axis = .horizontal,
        count: Int,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        lineLength: CGFloat,
        skip: LinearScaleShape.Skip? = nil,
        skipFirst: Int = 0,
        skipLast: Int = 0,
        skipCurrentValue: Bool = false,
        startFromCenter: Bool = false
    ) -> ScaleShapeStyle {
        .init(
            color: color,
            style: .linear(
                strokeStyle: strokeStyle,
                axis: axis,
                count: count,
                lineLength: lineLength,
                skip: skip,
                skipFirst: skipFirst,
                skipLast: skipLast,
                skipCurrentValue: skipCurrentValue,
                startFromCenter: startFromCenter
            )
        )
    }
    
    /// Creates a circular scale shape style.
    ///
    /// - Parameters:
    ///   - count: a count of the scale lines.
    ///   - color: a color of the scale lines.
    ///   - strokeStyle: a stroke style of the scale lines.
    ///   - minRadius: a minimum radius of the scale lines. The value is normalized from 0 to 1.
    ///   - maxRadius: a maximum radius of the scale lines. The value is normalized from 0 to 1.
    public static func circular(
        count: Int,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 1
    ) -> ScaleShapeStyle {
        circular(
            step: .init(degrees: 360 / (count > 0 ? Double(count) : 8)),
            color: color,
            strokeStyle: strokeStyle,
            minRadius: minRadius,
            maxRadius: maxRadius
        )
    }
    
    /// Creates a circular scale shape style.
    ///
    /// - Parameters:
    ///  - step: an angle step between the scale lines.
    ///  - color: a color of the scale lines.
    ///  - strokeStyle: a stroke style of the scale lines.
    ///  - minRadius: a minimum radius of the scale lines. The value is normalized from 0 to 1.
    ///  - maxRadius: a maximum radius of the scale lines. The value is normalized from 0 to 1.
    public static func circular(
        step: Angle,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 1
    ) -> ScaleShapeStyle {
        .init(
            color: color,
            style: .circular(
                strokeStyle: strokeStyle,
                step: step > .zero ? step : .init(degrees: 360 / 8),
                minRadius: minRadius,
                maxRadius: maxRadius
            )
        )
    }
    
    /// Creates a scale shape style with labels.
    ///
    /// - Parameters:
    ///  - visibility: a visibility style of the scale labels.
    ///  - axis: an axis of the scale.
    ///  - alignment: an alignment of the scale labels.
    ///  - color: a color of the scale labels.
    ///  - offset: an offset of the scale labels.
    ///  - labels: a dictionary of the scale labels. The key is a percentage of the scale and the value is a label.
    public static func labels(
        visibility: ScaleLabelsVisibility = .always,
        axis: Axis = .horizontal,
        alignment: Alignment = .center,
        color: Color = .secondary,
        offset: CGPoint = .zero,
        labels: [Double: String]
    ) -> ScaleShapeStyle {
        ScaleShapeStyle(
            color: color,
            style: .labels(
                visibility: visibility,
                axis: axis,
                alignment: alignment,
                offset: offset,
                labels: labels
            )
        )
    }
}
