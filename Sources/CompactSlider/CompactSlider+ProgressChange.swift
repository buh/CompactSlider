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
            Task {
                isValueChangingInternally = false
            }
        }
        
        if progress.isMultipleValues {
            values = newValue.progresses.map {
                convertProgressToValue($0)
            }
            
            return
        }
        
        if progress.isGridValues {
            point = .init(
                x: newValue.progresses[0].convertPercentageToValue(in: pointBounds.rangeX, step: pointStep.x),
                y: newValue.progresses[1].convertPercentageToValue(in: pointBounds.rangeY, step: pointStep.y)
            )
            
            return
        }
        
        lowerValue = convertProgressToValue(newValue.progresses[0])
        
        guard progress.isRangeValues else { return }
        
        upperValue = convertProgressToValue(newValue.progresses[1])
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        newValue.convertPercentageToValue(in: bounds, step: step)
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
    
    func onValue2DChange(_ newValue: Point) {
        if isValueChangingInternally { return }
        
        progress.progresses[0] = newValue.x.convertValueToPercentage(in: pointBounds.rangeX)
            .clampedOrRotated(withRotaion: options.contains(.loopValues))
        
        progress.progresses[1] = newValue.y.convertValueToPercentage(in: pointBounds.rangeY)
            .clampedOrRotated(withRotaion: options.contains(.loopValues))
    }
    
    func convertValueToProgress(_ value: Value) -> Double {
        value.convertValueToPercentage(in: bounds).clampedOrRotated(withRotaion: options.contains(.loopValues))
    }
}
