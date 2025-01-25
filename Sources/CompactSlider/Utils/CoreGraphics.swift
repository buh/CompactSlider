// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension CGSize {
    var minValue: CGFloat { Swift.min(width, height) }
    var min: CGSize { CGSize(width: minValue, height: minValue) }
}

extension CGPoint {
    init(angle: Angle, radius: CGFloat, in rect: CGRect) {
        self.init(angle: angle, radius: radius, in: rect.size)
    }
    
    init(angle: Angle, radius: CGFloat, in size: CGSize) {
        let x = size.width / 2 + radius * cos(angle.radians)
        let y = size.height / 2 + radius * sin(angle.radians)
        self.init(x: x, y: y)
    }
    
    func calculateAngle(from origin: CGPoint = .zero) -> Angle {
        Angle(radians: atan2(y - origin.y, x - origin.x))
    }
    
    func calculateDistance(from origin: CGPoint = .zero) -> CGFloat {
        sqrt((x - origin.x) * (x - origin.x) + (y - origin.y) * (y - origin.y))
    }
}
