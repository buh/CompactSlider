// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation
import CoreGraphics

public protocol CompactSliderPoint: Equatable, Comparable {
    associatedtype Value: BinaryFloatingPoint
    var x: Value { get }
    var y: Value { get }
    
    init(x: Value, y: Value)
}

public extension CompactSliderPoint {
    static var zero: Self { Self(x: 0, y: 0) }
    static var one: Self { Self(x: 1, y: 1) }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.x < rhs.x || (lhs.x == rhs.x && lhs.y < rhs.y)
    }
}

// MARK: - Adopt CGPoint to CompactSliderPoint

extension CGPoint: @retroactive Comparable {}
extension CGPoint: CompactSliderPoint {}

// MARK: - Placeholder

public struct CompactSliderPointValue<Value: BinaryFloatingPoint>: CompactSliderPoint {
    public let x: Value
    public let y: Value
    
    public init(x: Value, y: Value) {
        self.x = x
        self.y = y
    }
}
