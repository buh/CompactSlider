// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

extension BinaryFloatingPoint {
    /// Converts the value to a percentage in the given bounds.
    /// - Parameters:
    ///   - bounds: the value bounds
    /// - Returns: a percentage in the bounds from 0 to 1.
    public func convertValueToPercentage(in bounds: ClosedRange<Self>) -> Double {
        let distance = Double(bounds.distance)
        
        guard distance > 0 else { return 0 }
        
        return Double(self - bounds.lowerBound) / distance
    }
    
    public func rounded(toStep step: Self) -> Self {
        guard step > 0 else { return self }
        
        return (self / step).rounded() * step
    }
}

extension Double {
    /// Converts the percentage to a value in bounds and rounded with the step.
    /// - Parameters:
    ///   - bounds: the value bounds.
    ///   - step: the step to rounde the value.
    /// - Returns: a value in bounds.
    public func convertPercentageToValue<Value: BinaryFloatingPoint>(
        in bounds: ClosedRange<Value>,
        step: Value? = nil
    ) -> Value {
        let value = (bounds.lowerBound + Value(self) * bounds.distance)
        
        if let step {
            return value.rounded(toStep: step)
        }
        
        return value
    }
}
