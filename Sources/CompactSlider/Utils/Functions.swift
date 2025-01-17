// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension Comparable where Self: BinaryFloatingPoint {
    func clampedOrRotated(rotated rotation: Bool)  ->  Self {
        rotation ? rotated() : clamped()
    }
    
    func rotated() -> Self {
        (self > 1 ? (self - 1) : (self < 0 ? (self + 1) : self)).clamped()
    }
    
    func clamped(_ from: Self = 0, _ to: Self = 1)  ->  Self {
        var value = self
        
        if value < from {
            value = from
        }
        
        if value > to {
            value = to
        }
        
        return value
    }
}
