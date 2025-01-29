// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import Foundation
import CoreGraphics

/// A point value protocol for the grid slider. It's a pair of x and y values.
public protocol CompactSliderPoint: Equatable, Comparable {
    associatedtype Value: BinaryFloatingPoint
    var x: Value { get }
    var y: Value { get }
    
    init(x: Value, y: Value)
}

extension CompactSliderPoint {
    /// Returns zero point.
    public static var zero: Self { Self(x: 0, y: 0) }
    /// Returns a point with x and y values equal to 1.
    public static var one: Self { Self(x: 1, y: 1) }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y < rhs.y)
    }
}

// MARK: - Adopt CGPoint to CompactSliderPoint

extension CGPoint: @retroactive Comparable {}
extension CGPoint: CompactSliderPoint {}

// MARK: - Placeholder

/// A point value type for the grid slider.
public struct CompactSliderPointValue<Value: BinaryFloatingPoint>: CompactSliderPoint {
    public let x: Value
    public let y: Value
    
    public init(x: Value, y: Value) {
        self.x = x
        self.y = y
    }
}
