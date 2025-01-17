// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct GaugeStyle {
    public let fromAngle: Angle
    public let toAngle: Angle
    public let fillStyle: AnyShapeStyle
    public let strokeStyle: StrokeStyle
        
    public init<Fill: ShapeStyle>(
        fromAngle: Angle = .degrees(50),
        toAngle: Angle = .degrees(50),
        fillStyle: Fill,
        strokeStyle: StrokeStyle
    ) {
        let fromAngle = fromAngle
        let toAngle = toAngle < .zero ? toAngle + .degrees(360) : toAngle
        
        if fromAngle > toAngle {
            self.fromAngle = toAngle
            self.toAngle = fromAngle
        } else {
            self.fromAngle = fromAngle
            self.toAngle = toAngle
        }
        
        self.fillStyle = AnyShapeStyle(fillStyle)
        self.strokeStyle = strokeStyle
    }
}

extension GaugeStyle {
    public init<Fill: ShapeStyle>(
        fromAngle: Angle = .degrees(50),
        toAngle: Angle = .degrees(-50),
        fillStyle: Fill,
        lineWidth: CGFloat
    ) {
        self.init(
            fromAngle: fromAngle,
            toAngle: toAngle,
            fillStyle: fillStyle,
            strokeStyle: .init(lineWidth: lineWidth, lineCap: .round)
        )
    }
    
    public init(
        fromAngle: Angle = .degrees(50),
        toAngle: Angle = .degrees(-50),
        color: Color = Defaults.backgroundColor,
        lineWidth: CGFloat
    ) {
        self.init(
            fromAngle: fromAngle,
            toAngle: toAngle,
            fillStyle: color,
            strokeStyle: .init(lineWidth: lineWidth, lineCap: .round)
        )
    }
}
