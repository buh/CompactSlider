// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderPolarPoint: Hashable {
    public let angle: Angle
    /// A related radius in 0...1.
    public let normalizedRadius: Double
    
    public init(angle: Angle, normalizedRadius: Double) {
        self.angle = angle
        self.normalizedRadius = normalizedRadius
    }
    
    func rounded(_ step: CompactSliderPolarPoint) -> Self {
        .init(
            angle: .degrees(angle.degrees.rounded(step: step.angle.degrees)),
            normalizedRadius: normalizedRadius.rounded(step: step.normalizedRadius)
        )
    }
    
    func toCartesian(size: CGSize) -> CGPoint {
        let radius = normalizedRadius * size.minValue / 2
        let x = size.width / 2 + radius * cos(angle.radians)
        let y = size.height / 2 + radius * sin(angle.radians)
        return CGPoint(x: x, y: y)
    }
}

extension CompactSliderPolarPoint: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.angle < rhs.angle ||
        (lhs.angle == rhs.angle && lhs.normalizedRadius < rhs.normalizedRadius)
    }
}

// MARK: - Defaults

extension CompactSliderPolarPoint {
    public static let zero = CompactSliderPolarPoint(angle: .zero, normalizedRadius: 0)
    public static let full = CompactSliderPolarPoint(angle: .degrees(360), normalizedRadius: 1)
}
