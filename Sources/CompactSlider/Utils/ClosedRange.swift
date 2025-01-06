// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
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

extension ClosedRange where Bound: CompactSliderPoint, Bound.Value: BinaryFloatingPoint {
    @inlinable
    var rangeX: ClosedRange<Bound.Value> { lowerBound.x ... upperBound.x }
    
    @inlinable
    var rangeY: ClosedRange<Bound.Value> { lowerBound.y ... upperBound.y }
    
    @inlinable
    var distanceX: Bound.Value { upperBound.x - lowerBound.x }
    
    @inlinable
    var distanceY: Bound.Value { upperBound.y - lowerBound.y }
}
