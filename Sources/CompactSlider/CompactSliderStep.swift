// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// Defines the step for a slider. It can be linear, point, or polar point, depending on the slider type.
///
/// Linear slider:
/// - The `linear` step is used for a linear value for horizontal or vertical (scrollable) sliders.
/// - The `point` step is used for a grid slider.
/// - The `polarPoint` step is used for a circular grid.
/// - The `linearStep` is used for the step value.
/// - The `linearProgressStep` is used for the progress step for a linear step.
/// - The `linearSteps` is used for the number of steps for a linear step.
///
/// Grid slider:
/// - The `pointStep` is used for the step value for a point.
/// The `pointProgressStep` is used for the progress step for a point step.
/// The `pointSteps` is used for the number of steps for a point step.
///
/// Circular Grid slider:
/// - The `polarPointProgressStep` is used for the progress step for a polar point step.
/// - The `polarPointSteps` is used for the number of steps for a polar point step.
public enum CompactSliderStep: Equatable {
    /// A point progress step for a grid slider.
    public struct PointValue: Equatable {
        public let x: Double
        public let y: Double
    }
    
    /// A point steps for a grid slider.
    public struct PointSteps: Equatable {
        public let x: Int
        public let y: Int
    }
    
    /// A polar point steps for a circular grid slider.
    public struct PolarPointSteps: Equatable {
        public let angle: Int
        public let radius: Int
    }
    
    case linear(valueStep: Double, progressStep: Double, steps: Int)
    case point(valueStep: PointValue, progressStep: PointValue, steps: PointSteps)
    case polarPoint(valueStep: CompactSliderPolarPoint, progressStep: CompactSliderPolarPoint, steps: PolarPointSteps)
    
    /// A linear slider step value.
    public func linearStep<Value: BinaryFloatingPoint>() -> Value {
        if case .linear(let step, _, _) = self {
            return Value(step)
        }
        
        return 0
    }
    
    /// A linear slider progress step value.
    public var linearProgressStep: Double? {
        if case .linear(_, let step, _) = self {
            return step
        }
        
        return nil
    }
    
    /// A linear slider number of steps.
    public var linearSteps: Int? {
        if case .linear(_, _, let steps) = self {
            return steps
        }
        
        return nil
    }
    
    /// A point step value for a grid slider.
    public func pointStep<Value: BinaryFloatingPoint>() -> (x: Value, y: Value)? {
        if case .point(let step, _, _) = self {
            return (x: Value(step.x), y: Value(step.y))
        }
        
        return nil
    }
    
    /// A point progress step for a grid slider.
    public var pointProgressStep: PointValue? {
        if case .point(_, let progressStep, _) = self {
            return progressStep
        }
        
        return nil
    }
    
    /// A number of steps for a grid slider.
    public var pointSteps: PointSteps? {
        if case .point(_, _, let steps) = self {
            return steps
        }
        
        return nil
    }
    
    /// A polar point progress step for a circular grid slider.
    public var polarPointProgressStep: CompactSliderPolarPoint? {
        if case .polarPoint(_, let progressStep, _) = self {
            return progressStep
        }
        
        return nil
    }
    
    /// A number of steps for a circular grid.
    public var polarPointSteps: PolarPointSteps? {
        if case .polarPoint(_, _, let steps) = self {
            return steps
        }
        
        return nil
    }
}

extension CompactSliderStep {
    init?<T: BinaryFloatingPoint>(bounds: ClosedRange<T>, step: T) {
        guard step > 0 else { return nil }
        
        self = .linear(
            valueStep: Double(step),
            progressStep: bounds.progressStep(step: step),
            steps: bounds.steps(step: step)
        )
    }
    
    init?<T: CompactSliderPoint>(bounds: ClosedRange<T>, pointStep: T) {
        guard pointStep.x > 0, pointStep.y > 0 else { return nil }
        
        self = .point(
            valueStep: .init(x: Double(pointStep.x), y: Double(pointStep.y)),
            progressStep: .init(
                x: bounds.rangeX.progressStep(step: pointStep.x),
                y: bounds.rangeY.progressStep(step: pointStep.y)
            ),
            steps: .init(x: bounds.rangeX.steps(step: pointStep.x), y: bounds.rangeY.steps(step: pointStep.y))
        )
    }
    
    init?(polarPointStep: CompactSliderPolarPoint) {
        guard polarPointStep.angle.degrees > 0, polarPointStep.normalizedRadius > 0 else { return nil }
        
        self = .polarPoint(
            valueStep: polarPointStep,
            progressStep: polarPointStep,
            steps: .init(
                angle: Int((360.0 / polarPointStep.angle.degrees).rounded()) + 1,
                radius: Int((1.0 / polarPointStep.normalizedRadius).rounded()) + 1
            )
        )
    }
}
