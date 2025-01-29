// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A polar point for a circular grid type.
///
/// The angle is in degrees from 0 to 360. The radius is a normalized value from 0 to 1.
/// The center of the circle is in the center of the view.
/// The radius is a half of the min size of the view.
public struct CompactSliderPolarPoint: Hashable {
    /// An angle.
    public let angle: Angle
    /// A normalized radius from 0 to 1.
    public let normalizedRadius: Double
    
    /// Create a polar point.
    /// - Parameters:
    ///  - angle: an angle.
    ///  - normalizedRadius: a normalized radius from 0 to 1.
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
        CGPoint(angle: angle, radius: normalizedRadius * size.minValue / 2, in: size)
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
    /// A zero angle and zero radius.
    public static let zero = CompactSliderPolarPoint(angle: .zero, normalizedRadius: 0)
    /// A zero angle and radius is 1.
    public static let full = CompactSliderPolarPoint(angle: .zero, normalizedRadius: 1)
}
