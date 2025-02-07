// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension CompactSlider {
    func onProgressesChange(_ newValue: Progress) {
        guard !newValue.progresses.isEmpty else { return }
        
        isValueChangingInternally = true
        defer {
            isValueChangingInternally = false
        }
        
        if progress.isMultipleValues {
            values = newValue.progresses.map {
                convertProgressToValue($0)
            }
            
            return
        }
        
        if progress.isGridValues {
            point = .init(
                x: newValue.progresses[0].convertPercentageToValue(
                    in: pointBounds.rangeX,
                    step: step?.pointStep()?.x
                ),
                y: newValue.progresses[1].convertPercentageToValue(
                    in: pointBounds.rangeY,
                    step: step?.pointStep()?.y
                )
            )
            
            return
        }
        
        if progress.isCircularGridValues {
            polarPoint = progress.polarPoint
            return
        }
        
        lowerValue = convertProgressToValue(newValue.progresses[0])
        
        guard progress.isRangeValues else { return }
        
        upperValue = convertProgressToValue(newValue.progresses[1])
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        newValue.convertPercentageToValue(in: bounds, step: step?.linearStep() ?? 0.0)
    }
    
    func onLowerValueChange(_ newValue: Value) {
        if isValueChangingInternally { return }
        progress.updateLowerProgress(convertValueToProgress(newValue))
    }
    
    func onUpperValueChange(_ newValue: Value) {
        if isValueChangingInternally { return }
        progress.updateUpperProgress(convertValueToProgress(newValue))
    }
    
    func onValuesChange(_ newValues: [Value]) {
        if isValueChangingInternally { return }
        progress.progresses = newValues.map(convertValueToProgress)
    }
    
    func onPointChange(_ newValue: Point) {
        if isValueChangingInternally { return }
        
        progress.progresses[0] = newValue.x.convertValueToPercentage(in: pointBounds.rangeX)
            .clampedOrRotated(rotated: options.contains(.loopValues))
        
        progress.progresses[1] = newValue.y.convertValueToPercentage(in: pointBounds.rangeY)
            .clampedOrRotated(rotated: options.contains(.loopValues))
    }
    
    func onPolarPointChange(_ newValue: CompactSliderPolarPoint) {
        if isValueChangingInternally { return }
        progress.updatePolarPoint(newValue)
    }
    
    func convertValueToProgress(_ value: Value) -> Double {
        value.convertValueToPercentage(in: bounds)
            .clampedOrRotated(rotated: options.contains(.loopValues))
    }
}
