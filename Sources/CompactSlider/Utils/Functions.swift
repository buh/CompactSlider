// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension Comparable where Self: BinaryFloatingPoint {
    func clampedOrRotated(withRotaion rotation: Bool)  ->  Self {
        rotation ? rotated() : clamped()
    }
    
    func rotated() -> Self {
        (self > 1 ? (self - 1) : (self < 0 ? (self + 1) : self)).clamped()
    }
    
    func clamped(_ f: Self = 0, _ t: Self = 1)  ->  Self {
        var value = self
        
        if value < f {
            value = f
        }
        
        if value > t {
            value = t
        }
        
        return value
    }
}
