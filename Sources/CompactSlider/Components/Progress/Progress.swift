// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

/// Progress values.
public struct Progress: Equatable {
    /// All progress values.
    public internal(set) var progresses: [Double]
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    public var progress: Double { progresses.first ?? 0 }
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should be used to track a single value or a lower value for a range of values.
    public var lowerProgress: Double { progresses.first ?? 0 }
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should only be used to track the upper value for the range of values.
    public var upperProgress: Double { isRangeValues ? progresses.last ?? 0 : 0 }
    /// True if the slider uses a single value.
    public var isSingularValue: Bool { progresses.count == 1 }
    /// True if the slider uses a range of values.
    public var isRangeValues: Bool { progresses.count == 2 }
    /// True if the slider uses multiple values.
    public let isMultipleValues: Bool
    
    init(_ progresses: [Double] = [], isMultipleValues: Bool = false) {
        self.progresses = progresses
        self.isMultipleValues = isMultipleValues
    }
    
    mutating func update(_ progress: Double, at index: Int) {
        guard index < progresses.count else { return }
        
        progresses[index] = progress
    }
    
    mutating func updateLowerProgress(_ progress: Double) {
        update(progress, at: 0)
    }
    
    mutating func updateUpperProgress(_ progress: Double) {
        update(progress, at: 1)
    }
}
