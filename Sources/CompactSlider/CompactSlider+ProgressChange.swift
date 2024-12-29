// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
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
        
        lowerValue = convertProgressToValue(newValue.progresses[0])
        
        guard progress.isRangeValues else { return }
        
        upperValue = convertProgressToValue(newValue.progresses[1])
        
        guard progress.isMultipleValues else { return }
        
        values = newValue.progresses.map(convertProgressToValue)
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        let value = bounds.lowerBound + Value(newValue) * bounds.distance
        return step > 0 ? (value / step).rounded() * step : value
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

    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(bounds.distance)
        return length != 0 ? Double(newValue - bounds.lowerBound) / length : 0
    }
}
