// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import Foundation

/// A progress of a slider. Progress contains the current percentage of the progress
/// and provides a value from the progress.
///
/// Progress can be a single value, a range of values, or a grid, or a circular grid.
/// The progress is a value between 0 and 1.
public struct Progress: Equatable {
    /// All progress values.
    public internal(set) var progresses: [Double]
    
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    ///
    /// Use case: a single value.
    public var progress: Double { progresses.first ?? 0 }
    
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should be used to track a single value or a lower value for a range of values.
    ///
    /// Use case: a range of values. The lower value.
    public var lowerProgress: Double { progresses.first ?? 0 }
    
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should only be used to track the upper value for the range of values.
    ///
    /// Use case: a range of values. The upper value.
    public var upperProgress: Double { isRangeValues ? progresses.last ?? 0 : 0 }
    
    /// True if the slider uses a single value.
    public var isSingularValue: Bool { progresses.count == 1 }
    /// True if the slider uses a range of values.
    public var isRangeValues: Bool { progresses.count == 2 }
    /// True if the slider uses multiple values.
    public let isMultipleValues: Bool
    /// True if the slider uses grid values.
    public let isGridValues: Bool
    /// True if the slider uses circular grid values.
    public let isCircularGridValues: Bool
    
    /// The point progress. It's used for a grid slider.
    public var pointProgress: CompactSliderPointValue<Double> {
        guard progresses.count == 2 else {
            return .zero
        }
        
        return .init(x: progresses[0], y: progresses[1])
    }
    
    /// The polar point of the progress. It's used for a circular grid slider.
    public var polarPoint: CompactSliderPolarPoint {
        guard progresses.count == 2 else {
            return .zero
        }
        
        return CompactSliderPolarPoint(
            angle: .degrees(progresses[0]),
            normalizedRadius: progresses[1]
        )
    }
    
    init(
        _ progresses: [Double] = [],
        isMultipleValues: Bool = false,
        isGridValues: Bool = false,
        isCircularGridValues: Bool = false
    ) {
        self.progresses = progresses
        self.isMultipleValues = isMultipleValues
        self.isGridValues = isGridValues
        self.isCircularGridValues = isCircularGridValues
    }
    
    init(_ polarPoint: CompactSliderPolarPoint) {
        progresses = [
            polarPoint.angle.degrees,
            polarPoint.normalizedRadius
        ]
        
        isMultipleValues = false
        isGridValues = false
        isCircularGridValues = true
    }
    
    @discardableResult
    mutating func update(_ progress: Double, at index: Int) -> Bool {
        guard index < progresses.count, progresses[index] != progress else {
            return false
        }
        
        progresses[index] = progress
        return true
    }
    
    mutating func updateLowerProgress(_ progress: Double) {
        update(progress, at: 0)
    }
    
    mutating func updateUpperProgress(_ progress: Double) {
        update(progress, at: 1)
    }
    
    mutating func updatePoint(rounded step: CompactSliderStep.PointValue) {
        update(progresses[0].rounded(step: step.x), at: 0)
        update(progresses[1].rounded(step: step.y), at: 1)
    }
    
    @discardableResult
    mutating func updatePolarPoint(
        _ polarPoint: CompactSliderPolarPoint
    ) -> (angle: Bool, radius: Bool) {
        let radius = polarPoint.normalizedRadius.clamped()
        
        let updatedAngle = update(
            radius == 0 ? .zero : polarPoint.angle.degrees.clamped(0, 360),
            at: 0)
        
        let updatedRadius = update(radius, at: 1)
        
        return (updatedAngle, updatedRadius)
    }
    
    public func value<Value: BinaryFloatingPoint>(
        in bounds: ClosedRange<Value>,
        step: Value = 0,
        at index: Int = 0
    ) -> Value {
        guard index < progresses.count else {
            assertionFailure("Index \(index) is out of bounds.")
            return bounds.lowerBound
        }
        
        return progresses[index].convertPercentageToValue(in: bounds, step: step)
    }
}
