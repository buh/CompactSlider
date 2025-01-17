// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum CompactSliderStep: Equatable {
    public struct PointValue: Equatable {
        public let x: Double
        public let y: Double
    }
    
    public struct PointSteps: Equatable {
        public let x: Int
        public let y: Int
    }
    
    public struct PolarPointSteps: Equatable {
        public let angle: Int
        public let radius: Int
    }
    
    case linear(valueStep: Double, progressStep: Double, steps: Int)
    case point(valueStep: PointValue, progressStep: PointValue, steps: PointSteps)
    case polarPoint(valueStep: CompactSliderPolarPoint, progressStep: CompactSliderPolarPoint, steps: PolarPointSteps)
    
    public func linearStep<Value: BinaryFloatingPoint>() -> Value {
        if case .linear(let step, _, _) = self {
            return Value(step)
        }
        
        return 0
    }
    
    public var linearProgressStep: Double? {
        if case .linear(_, let step, _) = self {
            return step
        }
        
        return nil
    }
    
    public var linearSteps: Int? {
        if case .linear(_, _, let steps) = self {
            return steps
        }
        
        return nil
    }
    
    public func pointStep<Value: BinaryFloatingPoint>() -> (x: Value, y: Value)? {
        if case .point(let step, _, _) = self {
            return (x: Value(step.x), y: Value(step.y))
        }
        
        return nil
    }
    
    public var pointProgressStep: PointValue? {
        if case .point(_, let progressStep, _) = self {
            return progressStep
        }
        
        return nil
    }
    
    public var pointSteps: PointSteps? {
        if case .point(_, _, let steps) = self {
            return steps
        }
        
        return nil
    }
    
    public var polarPointProgressStep: CompactSliderPolarPoint? {
        if case .polarPoint(_, let progressStep, _) = self {
            return progressStep
        }
        
        return nil
    }
    
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
        
        let polarPointProgressStep = CompactSliderPolarPoint(
            angle: Angle(degrees: polarPointStep.angle.degrees / 360.0),
            normalizedRadius: polarPointStep.normalizedRadius
        )
        
        self = .polarPoint(
            valueStep: polarPointStep,
            progressStep: polarPointProgressStep,
            steps: .init(
                angle: Int((360.0 / polarPointProgressStep.angle.degrees).rounded()) + 1,
                radius: Int((1.0 / polarPointProgressStep.normalizedRadius).rounded()) + 1
            )
        )
    }
}
