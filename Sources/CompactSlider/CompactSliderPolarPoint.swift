// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSliderPolarPoint: Equatable {
    public let angle: Angle
    /// A related radius in 0...1.
    public let radius: Double
    
    public init(angle: Angle, radius: Double) {
        self.angle = angle
        self.radius = max(0, min(1, radius))
    }
    
    func toCartesian(size: CGSize) -> CGPoint {
        let radius = radius * min(size.width, size.height) / 2
        let x = size.width / 2 + radius * cos(angle.radians)
        let y = size.height / 2 + radius * sin(angle.radians)
        return CGPoint(x: x, y: y)
    }
}

extension CompactSliderPolarPoint: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.angle < rhs.angle || (lhs.angle == rhs.angle && lhs.radius < rhs.radius)
    }
}

// MARK: - Defaults

public extension CompactSliderPolarPoint {
    static var zero: Self { .init(angle: .zero, radius: 0) }
    static var full: Self { .init(angle: .degrees(360), radius: 1) }
}
