// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum ScaleShapeStyle: Hashable {
    case linear(
        axis: Axis,
        count: Int,
        minSpacing: CGFloat,
        skip: LinearScaleShape.Skip?,
        skipFirst: Int,
        skipLast: Int,
        startFromCenter: Bool
    )
    
    case circular(
        step: Angle,
        minRadius: Double,
        maxRadius: Double
    )
    
    var axis: Axis? {
        if case .linear(let axis, _, _, _, _, _, _) = self {
            return axis
        }
        
        return nil
    }
}

public struct ScaleView: View {
    let color: Color
    let strokeStyle: StrokeStyle
    let lineLength: CGFloat
    let shapeStyle: ScaleShapeStyle
    
    public var body: some View {
        switch shapeStyle {
        case .linear(
            let axis,
            let count,
            let minSpacing,
            let skip,
            let skipFirst,
            let skipLast,
            let startFromCenter
        ):
            LinearScaleShape(
                axis: axis,
                count: count,
                thickness: strokeStyle.lineWidth,
                minSpacing: minSpacing,
                skip: skip,
                skipFirst: skipFirst,
                skipLast: skipLast,
                startFromCenter: startFromCenter
            )
            .stroke(color, style: strokeStyle)
            .frame(
                width: (shapeStyle.axis == .vertical ? lineLength : nil),
                height: (shapeStyle.axis == .horizontal ? lineLength : nil)
            )
        case .circular(let step, let minRadius, let maxRadius):
            CircularScaleShape(step: step, minRadius: minRadius, maxRadius: maxRadius)
                .stroke(color, style: strokeStyle)
        }
    }
}

extension ScaleView: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(lineLength)
        hasher.combine(shapeStyle)
        hasher.combine(strokeStyle.lineWidth)
        hasher.combine(strokeStyle.lineCap)
        hasher.combine(strokeStyle.lineJoin)
        hasher.combine(strokeStyle.miterLimit)
        hasher.combine(strokeStyle.dash)
        hasher.combine(strokeStyle.dashPhase)
    }
}

// MARK: - Constructors

extension ScaleView {
    public static func linear(
        count: Int,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        lineLength: CGFloat,
        axis: Axis = .horizontal,
        skip: LinearScaleShape.Skip? = nil,
        skipFirst: Int = 0,
        skipLast: Int = 0,
        startFromCenter: Bool = false
    ) -> ScaleView {
        ScaleView(
            color: color,
            strokeStyle: strokeStyle,
            lineLength: lineLength,
            shapeStyle: .linear(
                axis: axis,
                count: count,
                minSpacing: 2,
                skip: skip,
                skipFirst: skipFirst,
                skipLast: skipLast,
                startFromCenter: startFromCenter
            )
        )
    }
    
    public static func circular(
        count: Int,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 1
    ) -> ScaleView {
        ScaleView(
            color: color,
            strokeStyle: strokeStyle,
            lineLength: 0,
            shapeStyle: .circular(
                step: .init(degrees: 360 / count > 0 ? Double(count) : 8),
                minRadius: minRadius,
                maxRadius: maxRadius
            )
        )
    }
    
    public static func circular(
        step: Angle,
        color: Color = Defaults.scaleLineColor,
        strokeStyle: StrokeStyle = .init(lineWidth: 1),
        minRadius: CGFloat = 0,
        maxRadius: CGFloat = 1
    ) -> ScaleView {
        ScaleView(
            color: color,
            strokeStyle: strokeStyle,
            lineLength: 0,
            shapeStyle: .circular(
                step: step > .zero ? step : .init(degrees: 360 / 8),
                minRadius: minRadius,
                maxRadius: maxRadius
            )
        )
    }
}

#Preview {
    VStack {
        ScaleView.linear(count: 20, lineLength: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
