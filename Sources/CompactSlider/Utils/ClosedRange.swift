// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension ClosedRange where Bound: BinaryFloatingPoint {
    @inlinable
    var distance: Bound { upperBound - lowerBound }
    
    func progressStep(step: Bound) -> Double {
        guard step > 0 else { return 0 }
        
        let distance = self.distance
        return Double(distance > 0 ? step / distance : 0)
    }
    
    func steps(step: Bound) -> Int {
        step > 0 ? Int((self.distance / step).rounded()) + 1 : 0
    }
}
