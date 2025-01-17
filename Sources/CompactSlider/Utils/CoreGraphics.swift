// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct OptionalCGSize {
    public let width: CGFloat?
    public let height: CGFloat?
    
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }
}

// MARK: - Internal

extension CGSize {
    var minValue: CGFloat { Swift.min(width, height) }
    var min: CGSize { CGSize(width: minValue, height: minValue) }
}

extension CGPoint {
    func calculateAngle(from origin: CGPoint = .zero) -> Angle {
        Angle(radians: atan2(y - origin.y, x - origin.x))
    }
    
    func calculateDistance(from origin: CGPoint = .zero) -> CGFloat {
        sqrt((x - origin.x) * (x - origin.x) + (y - origin.y) * (y - origin.y))
    }
}
