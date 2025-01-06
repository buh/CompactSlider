// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderPolarPoint: Equatable {
    public let angle: Angle
    public let radius: CGFloat
    
    public init(angle: Angle, radius: CGFloat) {
        self.angle = angle
        self.radius = radius
    }
    
    func toCartesian(center: CGPoint) -> CGPoint {
        let x = center.x + radius * cos(angle.radians)
        let y = center.y + radius * sin(angle.radians)
        return CGPoint(x: x, y: y)
    }
}

extension CompactSliderPolarPoint: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.angle < rhs.angle || (lhs.angle == rhs.angle && lhs.radius < rhs.radius)
    }
}
