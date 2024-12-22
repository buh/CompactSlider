// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension CompactSlider {
    func onProgressesChange(_ newValues: [Double]) {
        guard !newValues.isEmpty else { return }
        
        isValueChangingInternally = true
        defer {
            Task {
                isValueChangingInternally = false
            }
        }
        
        lowerValue = convertProgressToValue(newValues[0])
        
        guard isRangeValues else { return }
        
        upperValue = convertProgressToValue(newValues[1])
        
        guard isMultipleValues else { return }
        
        values = newValues.map(convertProgressToValue)
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        let value = bounds.lowerBound + Value(newValue) * bounds.distance
        return step > 0 ? (value / step).rounded() * step : value
    }
    
    func onLowerValueChange(_ newValue: Value) {
        if isValueChangingInternally { return }
        updateLowerProgress(convertValueToProgress(newValue))
    }
    
    func onUpperValueChange(_ newValue: Value) {
        if isValueChangingInternally { return }
        updateUpperProgress(convertValueToProgress(newValue))
    }
    
    func onValuesChange(_ newValues: [Value]) {
        if isValueChangingInternally { return }
        progresses = newValues.map(convertValueToProgress)
    }

    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(bounds.distance)
        return length != 0 ? Double(newValue - bounds.lowerBound) / length : 0
    }
}
